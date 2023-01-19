# Input a number
# Calculate the exponent, square root and convert to hexadecimal
# example: input i, calculate 2^i, square(i), and convert to hexa
.data
promt: .asciiz "Input: "
firstRow: .asciiz "i\tpower(2,i)\tsquare(i)\tHexadecimal(i)\n"
tooLarge: .asciiz "Too large"
tabs: .asciiz "\t\t"
Ox: .asciiz "0x"
result: .space 8
.text

.globl main



main:
# Nhap so
la $a0, promt
li $v0, 4
syscall

li $v0, 5
syscall # So vua nhap vào v0

move $t2, $v0 # Luu so vua nhap vao t2

# In dong dau
la $a0, firstRow
li $v0, 4
syscall # print "i power(2,i) square(i) Hexadecimal(i)\n"

# In ra i dong sau
move $a0, $t2
li $v0, 1
syscall # print i

# Tính 2^i
Power:
li $a0, '\t'
li $v0, 11
syscall # print tab

bge $t2, 32, iTooLarge # neu i>=32 thì chuyen den iTooLarge de in ra "too large"
blt $t2, 0, iNegative # neu i<0 thì chuyen den iNegative de in ra 0
li $t1, 1
sllv $t0, $t1, $t2 # dich so 1 ($t1) sang trái i bit, ta duoc 2^i

# in 2^i (dang luu o $t0)
move $a0, $t0
li $v0, 36
syscall
j Square

iNegative:
li $a0, 0
li $v0, 1
syscall # print power = 0
j Square

iTooLarge: # print 'too large'
la $a0, tooLarge
li $v0, 4
syscall
j Square

# Tính i^2
Square:
la $a0, tabs
li $v0, 4
syscall # print tabs

mult $t2, $t2 # tính i^2
mfhi $a0 # $a0 chua 32 bit sau cua i^2
bnez $a0, squareTooLarge # neu a0 khác 0 nghia la i^2 lon hon 32 bit, in ra "So quá lon"

mflo $a0
# in i^2, luu o $a0 (do 32 bit dau = 0)
li $v0, 36
syscall
j ToHex



squareTooLarge:
la $a0, tooLarge
li $v0, 4
syscall # print 'too large'
j ToHex



# in ra hexa cua i
ToHex:
la $a0, tabs
li $v0, 4
syscall # print tabs



la $t3, result # luu gia tri can tìm
addi $t3, $t3, 7

CalHex:
and $t4, $t2, 0xf # mask with 1111
srl $t2, $t2, 4
ble $t4, 9, ToDigit # neu <=9 thì chuyen sang toDigit
j ToChar # không thì se là ký tu, chuyen sang toChar

ToDigit:
addi $t4, $t4, 48 # thêm 48 vào ascii de chuyen tu so thành ký tu tuong ung
j Next

ToChar:
addi $t4, $t4, 55 # thêm 55 vào ascii de chuyen hexa thành ký tu tuong ung
j Next



Next:
sb $t4, 0($t3) # luu chu so hexa vào $t4
subi $t3, $t3, 1 # giam dia chi di 1
bnez $t2, CalHex # neu chua quét het chu so thì quay lai calHex tính tiep



# Quét het thì Exit
Exit:
# In "0x"
la $a0, Ox
li $v0, 4
syscall

# In chu?i Hex
addi $t3, $t3, 1
move $a0, $t3
li $v0, 4
syscall

li $a0, 0xA
li $v0, 11
syscall # print endline



j main # Chay mãi mãi

# Ket thúc
li $v0, 10
syscall # exit program
