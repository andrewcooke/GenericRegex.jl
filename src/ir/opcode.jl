
module OpCode

# this has to be a fixed size (single type) for efficiency (needs to
# pack into an array).  for simplicity(?) we go with the smallest
# format possible, which seems to be a type, an integer and a
# character

immutable Instruction{C}
    code::Int
    n::Int
    c::C
end

const EQ = 1  # fail if not eq (ignore n)
const GE = 2  # fail if not ge (ignore n)
const LE = 3  # fail if not le (ignore n)
const ALT = 4 # catch failure and jump to n (ignore c)

end
