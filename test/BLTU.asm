
#bltu ����    С�ڵ�������ת     �ۼ����㣬�Ӹ�����ʼ��������  revise date:2022/1/24 tiger  
#�������0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff 0x00000000
.text

addi s1,zero,-15       #��ʼֵ
bltu_branch:
add a0,zero,s1          
addi a7,zero,34         
#ecall                  #�����ǰֵ
addi s1,s1,1  
bltu zero,s1,bltu_branch   
add a0,zero,s1          
addi a7,zero,34         
#ecall                  #�����ǰֵ
end:
addi   a7,zero,10         
#ecall                  # ��ͣ���˳�