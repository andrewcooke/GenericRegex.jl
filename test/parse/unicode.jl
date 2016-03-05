
using ParserCombinator
using GenericRegex.IR.Graph; G = GenericRegex.IR.Graph
using GenericRegex.Parse.Unicode; U = GenericRegex.Parse.Unicode

for (s, r) in [
               ("abc", 
                [G.Sequence{Char}([G.Literal('a'), G.Literal('b'), G.Literal('c')])]),
               ("a|b", 
                [G.Choice{Char}([G.Literal('a'), G.Literal('b')])]),
               ("aa|b", 
                [G.Choice{Char}([G.Sequence{Char}([G.Literal('a'), G.Literal('a')]), G.Literal('b')])]),
               ("a|bb", 
                [G.Choice{Char}([G.Literal('a'), G.Sequence{Char}([G.Literal('b'), G.Literal('b')])])]),
               ("(a|b)", 
                [G.Group(1, G.Choice{Char}([G.Literal('a'), G.Literal('b')]))]),
               ("(a|(b))", 
                [G.Group(1, G.Choice{Char}([G.Literal('a'), G.Group(2, G.Literal('b'))]))]),
               ("(?:a|b)", 
                [G.Choice{Char}([G.Literal('a'), G.Literal('b')])]),
               ("a|b(?:c|d)", 
                [G.Choice{Char}([G.Literal('a'), G.Sequence{Char}([G.Literal('b'), G.Choice{Char}([G.Literal('c'), G.Literal('d')])])])]),
               ("a*",
                [G.Repeat(G.Literal('a'), 0, typemax(Int))]),
               ("a+",
                [G.Repeat(G.Literal('a'), 1, typemax(Int))]),
               ("ab+",
                [G.Sequence{Char}([G.Literal('a'), G.Repeat(G.Literal('b'), 1, typemax(Int))])]),
               ("a?a|b", 
                [G.Choice{Char}([G.Sequence{Char}([G.Repeat(G.Literal('a'), 0, 1), G.Literal('a')]), G.Literal('b')])]),
               ("aa?|b", 
                [G.Choice{Char}([G.Sequence{Char}([G.Literal('a'), G.Repeat(G.Literal('a'), 0, 1)]), G.Literal('b')])]),
               ("a|b?b", 
                [G.Choice{Char}([G.Literal('a'), G.Sequence{Char}([G.Repeat(G.Literal('b'), 0, 1), G.Literal('b')])])]),
               ("a|bb?", 
                [G.Choice{Char}([G.Literal('a'), G.Sequence{Char}([G.Literal('b'), G.Repeat(G.Literal('b'), 0, 1)])])]),
               ("a",
                [G.Literal('a')]),
               ("\\+",
                [G.Literal('+')])
               ]
    print("$s...")
    pattern = U.make_pattern()
    @test parse_dbg(s, pattern; debug=true) == r
    println(" ok")
end
