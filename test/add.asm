.text
addi x1, zero, 0 # loop var
addi x2, zero, 0 # sum var
addi x3, zero, 16 # end
loop:
add x2, x2, x1
addi x1, x1, 1
bne x1, x3, loop # if t0 != t1 then target

