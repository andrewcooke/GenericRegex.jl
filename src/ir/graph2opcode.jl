
module Graph2OpCode

import Basic.push!


function push!{C}(ins::Vector{Instruction{C}}, s::Sequence{C})
    for p in s.patterns
        push!(ins, p)
    end
end

function push!{C}(ins::Vector{Instruction{C}}, r::Range{C})
    if r.lo == r.hi
        push!(ins, Instruction{C}(EQ, 0, r.lo))
    else
        push!(ins, Instruction{C}(GE, 0, r.lo))
        push!(ins, Instruction{C}(LE, 0, r.hi))
    end
end

function push!{C}(ins::Vector{Instruction{C}}, c::Choice{C})
    jlast = length(c.patterns)
    for (j, p) in enumerate(c.patterns)
        if j != jlast
            i = Instruction{C}(ALT, 0, zero(C))
            push!(ins, p)
            i.n = length(ins) + 1
        else
            push!(ins, p)
        end
    end
end

function push!{C}(ins::Vector{Instruction{C}}, r::Repeat{C})
    
end

end
