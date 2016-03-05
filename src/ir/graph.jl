
module Graph

using AutoHashEquals


abstract Pattern{C}

@auto_hash_equals type Choice{C} <: Pattern{C}
    patterns::Vector{Pattern{C}}
end

@auto_hash_equals type Sequence{C} <: Pattern{C}
    patterns::Vector{Pattern{C}}
end

@auto_hash_equals type Repeat{C} <: Pattern{C}
    pattern::Pattern{C}
    lo::Int
    hi::Int
end

@auto_hash_equals type Range{C} <: Pattern{C}
    lo::C
    hi::C
end

Literal{C}(c::C) = Range{C}(c, c)
Wild{C}(::Type{C}) = Range(typemin(C), typemax(C))

@auto_hash_equals type Group{C} <: Pattern{C}
    index::Int
    pattern::Pattern{C}
end

end
