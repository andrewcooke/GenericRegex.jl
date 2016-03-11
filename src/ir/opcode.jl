
module OpCode

# this has to be a fixed size (single type) for efficiency (needs to
# pack into an array).  for simplicity(?) we go with a RISC approach.

immutable Instruction{C}
    code::Int
    n::Int
    c::C
end

