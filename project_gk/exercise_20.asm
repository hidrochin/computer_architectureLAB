# (20) Given a string which consists of lower alphabetic characters (a-z), count the
# number of different characters in it.
# Example: For s = "cabca", the output should be differentSymbolsNaive(s) = 3.
# There are 3 different characters a, b and c.

#Nguyen Ha Phu Thinh - 20205131

# $s0 luu so luong ki tu cua chuoi
# $s1 luu ket qua so ki tu khac nhau
# $s2 luu dia chi cua chuoi 1
# $s3 luu dia chi cua chuoi 2

.data
	message1: .asciiz "Nhap chuoi: "
	message2: .asciiz "So ki tu khac nhau cua chuoi la: "
	message3: .asciiz "Sai cu phap!"
	message4: .asciiz "Tiep tuc?"
	string1: .space 30
	string2: .space 30
.text
main:
	#Nhap chuoi ki tu
	li $v0, 54
	la $a0, message1
	la $a1, string1
	la $a2, 30
	syscall
	
	
	#Dem so ki tu trong chuoi
get_length: 
	la $a0,string1 # $a0 = address(string1[0])
	add $t0,$zero,$zero # $t0 = i = 0
check_char: add $t1,$a0,$t0 # $t1 = $a0 + $t0 
			   # = address(string1[i]) 
	lb $t2, 0($t1) # $t2 = string1[i]
	beq $t2, $zero, end_of_str # is null char? 
	addi $t0, $t0, 1 # $t0 = $t0 + 1 -> i = i + 1
 	j check_char
end_of_str:
end_of_get_length:
	addi $s0, $t0, -1 #s0 luu so ki tu cua chuoi

	#Kiem tra ki tu phu hop
	la $a0,string1 # $a0 = address(string[0])
	add $t0,$zero,$zero # $t0 = i = 0
check:	beq $t0, $s0, end_check
	add $t1,$a0,$t0 # $t1 = $a0 + $t0 = address(string1[i])
	lb $t2, 0($t1) # $t2 = string1[i]
	addi $t3, $t2, -96 # t3 = t2 - 96 = string1[i] - 96
	slt $t4, $zero, $t3 # if t3 > 0 then t4 = 1 else t4 = 0 
	beqz $t4, inform
	addi $t3, $t2, -123 # t3 = t2 - 123 = string[i] - 123
	slt $t4, $t3, $zero # if t3 < 0 then t4 = 1 else t4 = 0 
	beqz $t4, inform
	addi $t0, $t0, 1 # $t0 = $t0 + 1 -> i = i + 1
 	j check
	
inform:	
	li $v0, 55
	la $a0, message3
	syscall
	j continue	
		
end_check:			
	
	#Dem so ki tu khac nhau
	addi $s1, $zero, 1 # s1 luu ket qua so luong chu cai khac nhau
	la $s2, string1 # $s2 = dia chi string1[0]
	la $s3, string2 # $s3 = dia chi string2[0]
	lb $t2, 0($s2) # string2[0] = string1[0]
	sb $t2, 0($s3) # string2[0] = string1[0]

	
	addi $t0, $zero, 1 # t0 = i = 1
check1:	beq $t0, $s0, end_check1
	add $t2, $zero, $zero # bien dem count = t2 = 0
	add $t1, $zero, $zero # t1 = j = 0
check2:	beq $t1, $s1, end_check2
	add $t4, $s2, $t0 # t4 = tring1[0] + i = dia chi cua string1[i] 
	lb $t5, 0($t4) # t5 = gia tri cua tring1[i]
	add $t6, $s3, $t1  # t6 = tring2[0] + j = dia chi cua string2[j]
	lb $t7, 0($t6)  # t7 = gia tri cua tring2[j]
	beq $t5, $t7, add_count
point1:	addi $t1, $t1, 1
	j check2
end_check2:
	beq $t2, $zero, add_result
point2:	addi $t0, $t0, 1
	j check1
end_check1: j print_result

add_count:	addi $t2, $t2, 1
		j point1

add_result:	lb $t3, 0($t4) # t3 = string1[i]
		add $t8, $s1, $s3 # t8 = result + string2[0] = string[result]
		sb $t3, 0($t8) # t8 = gia tri cua t3 = string1[i]
		addi $s1, $s1, 1
		j point2
		
print_result:	li $v0, 56
		la $a0, message2
		add $a1, $s1, $zero
		syscall

continue:	li $v0, 50
		la $a0, message4	
		syscall
		beq $a0, $zero, main

exit:	li $v0, 10
	syscall
