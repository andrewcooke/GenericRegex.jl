
using ParserCombinator
using GenericRegex.Parse.Unicode; U = GenericRegex.Parse.Unicode

for (s, r) in [
               ("abc", 
                [U.Sequence([U.Literal('a'), U.Literal('b'), U.Literal('c')])]),
               ("a|b", 
                [U.Choice([U.Literal('a'), U.Literal('b')])]),
               ("aa|b", 
                [U.Choice([U.Sequence([U.Literal('a'), U.Literal('a')]), U.Literal('b')])]),
               ("a|bb", 
                [U.Choice([U.Literal('a'), U.Sequence([U.Literal('b'), U.Literal('b')])])]),
               ("(a|b)", 
                [U.Group(1, U.Choice([U.Literal('a'), U.Literal('b')]))]),
               ("(a|(b))", 
                [U.Group(1, U.Choice([U.Literal('a'), U.Group(2, U.Literal('b'))]))]),
               ("(?:a|b)", 
                [U.Choice([U.Literal('a'), U.Literal('b')])]),
               ("a|b(?:c|d)", 
                [U.Choice([U.Literal('a'), U.Sequence([U.Literal('b'), U.Choice([U.Literal("c"), U.Literal("d")])])])]),
               ("a*",
                [U.Repeat(U.Literal('a'), 0, typemax(Int))]),
               ("a+",
                [U.Repeat(U.Literal('a'), 1, typemax(Int))]),
               ("ab+",
                [U.Sequence([U.Literal('a'), U.Repeat(U.Literal('b'), 1, typemax(Int))])]),
               ("a?a|b", 
                [U.Choice([U.Sequence([U.Repeat(U.Literal('a'), 0, 1), U.Literal('a')]), U.Literal('b')])]),
               ("aa?|b", 
                [U.Choice([U.Sequence([U.Literal('a'), U.Repeat(U.Literal('a'), 0, 1)]), U.Literal('b')])]),
               ("a|b?b", 
                [U.Choice([U.Literal('a'), U.Sequence([U.Repeat(U.Literal('b'), 0, 1), U.Literal('b')])])]),
               ("a|bb?", 
                [U.Choice([U.Literal('a'), U.Sequence([U.Literal('b'), U.Repeat(U.Literal('b'), 0, 1)])])]),
               ("a",
                [U.Literal('a')]),
               ("\\+",
                [U.Literal('+')])
               ]
    print("$s...")
    pattern = U.make_pattern()
    @test parse_dbg(s, pattern; debug=true) == r
    println(" ok")
end
