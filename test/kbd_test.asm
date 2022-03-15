.text
li a1, 0xfbadbeef
start:
lb a2, -1(a1)
beq zero, a2, start
lb a0, 0(a1)
call sleep
j start

sleep:
li a5, 50000
loop:
addi a5, a5, -1
bge a5, zero, loop # if t0 >= t1 then target
ret


