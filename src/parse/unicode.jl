
module Unicode

using ParserCombinator
using GenericRegex
using GenericRegex.IR.Graph; G = GenericRegex.IR.Graph

#Literal(s::AbstractString) = (@assert length(s) == 1; Range(s[1], s[1]))

make_rpt(lo) = p -> G.Repeat(p, lo, typemax(Int))
make_rpt(lo, hi) = p -> G.Repeat(p, lo, hi)

make_char(s) = (@assert length(s) == 1; G.Literal(s[1]))


function make_pattern()

    @with_names begin

        # group numbering is tricky - we need to number fomr the left and
        # avoid repetitions on backtracking.  so push entries (keyed by
        # iter) to a stack on entering the group, pop on leaving.
        group_count = Dict{Any, Int}()
        group_stack = []
        group_popped = Dict{Any, Int}()
        function pre_group(i, p)
            if !haskey(group_count, i)
                group_count[i] = length(group_count) + 1
                push!(group_stack, group_count[i])
            end
            p
        end
        function post_group(i, p)
            if !haskey(group_popped, i)
                group_popped[i] = pop!(group_stack)
            end
            G.Group{Char}(group_popped[i], p)
        end
        
        make_sequence(p) = length(p) == 1 ? p[1] : G.Sequence{Char}(p)
        make_choice(p) = length(p) == 1 ? p[1] : G.Choice{Char}(p)
        
        
        literal = p"[^[\].*+\\|(){}?]"                       > make_char
        escaped = ~Equal("\\") + Dot()                       > G.Literal
        wild = E"."                                          > ()->G.Wild(Char)
        outseq = Delayed()
        
        atom = literal | escaped | wild | outseq
        plus = atom + E"+"                                   > make_rpt(1)
        star = atom + E"*"                                   > make_rpt(0)
        opt = atom + E"?"                                    > make_rpt(0, 1)
        once = atom + !(E"*"|E"+"|E"?")
        
        inseq = Plus(plus | star | opt | once)              |> make_sequence
        choice = PlusList(inseq, E"|")                      |> make_choice
        
        open = ITransform(E"("+ !(e"?") ,                      pre_group)
        gchoice = IApp(open + choice + E")",                   post_group)
        nchoice = E"(?:" + choice + E")"
        
        outseq.matcher = Plus(gchoice | nchoice)            |> make_sequence
        
        return choice + Eos()
    end
end

end
