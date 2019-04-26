.data
	p_day: .space 3
	p_month: .space 3
	p_year: .space 5

	tem_day: .space 3
	tem_month: .space 3
	tem_year: .space 5
	
	p_time: .asciiz "01/09/1999"
	p_time_1: .asciiz "01/09/1999"
	p_convert_time: .space 20
	
	# months
	jan: .asciiz "Jan"
	feb: .asciiz "Feb"
	mar: .asciiz "Mar"
	apr: .asciiz "Apr"
	may: .asciiz "May"
	jun: .asciiz "Jun"
	jul: .asciiz "Jul"
	aug: .asciiz "Aug"
	sep: .asciiz "Sep"
	oct: .asciiz "Oct"
	nov: .asciiz "Nov"
	dec: .asciiz "Dec"
	nameOfMonth: .word jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
	daysOfMonth: .word 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	
	#weekday
	sun: .asciiz "Sun"
	mon: .asciiz "Mon"
	tues: .asciiz "Tues"
	wed: .asciiz "Wed"
	thurs: .asciiz "Thurs"
	fri: .asciiz "Fri"
	sat: .asciiz "Sat"	

	# prompt
	prompt1: .asciiz "\nNhap ngay DAY dang DD: "
	prompt2: .asciiz "\nNhap thang MONTH dang MM: "
	prompt3: .asciiz "\nNhap nam YEAR dang YYYY: "
	
	menutable: .word option1, option2, option3, option4, option5, option6, option7
	# menu
	MENU: .asciiz 	"----------Ban hay chon 1 trong cac thao tac duoi day----------\n"
	menu:	.asciiz	"\n1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n\2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n\tA. MM/DD/YYYY\n\tB. Month DD, YYYY\n\tC. DD Month, YYYY\n3. Cho biet ngay vua nhap la ngay thu may trong tuan:\n4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong\n5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n7. Kiem tra du lieu nhap vao\n"
	
	option: .asciiz	"\nLua chon: "
	type: .asciiz "Loai (A/B/C): "
	result: .asciiz "\nKet qua: "
	m_continue: .asciiz "\nChon (1) de tiep tuc, (0) de thoat:  "
	leap: .asciiz " la nam nhuan."
	notleap: .asciiz " khong la nam nhuan."
	errorMessage: "\nKiem tra lai du lieu nhap vao. "
	message: "\nDu lieu nhap vao thoa man. "
	endline: .asciiz "\n"
	tab: .asciiz "\t"
	dateOfWeek: .asciiz "Ngay trong tuan la "
	distance:.asciiz "Khoang cach giua 2 ngay la "
	nextLeapYear:.asciiz "Hai nam nhuan tiep theo la:"
.text
	.globl main

main:	

while:
	la	$a0, p_time
	jal	Menu
	
	
	la	$a0, m_continue # If I want to continuous
	addi	$v0, $0, 4
	syscall

	addi	$v0, $0, 5
	syscall	
	
	la	$a0, p_time
	la	$a1, p_time_1
	jal 	Strcpy
	
	beq	$v0, $0, endP
	j	while
endP:
	addi	$v0, $0, 10
	syscall
	
Menu:
	addi	$sp, $sp, -40
	sw 	$t0, 0($sp)
	sw	$ra, 4($sp)
	sw	$t1, 12($sp)
	sw	$t2, 16($sp)
	sw	$t3, 20($sp)
	sw	$a0, 24($sp)
	sw	$a1, 28($sp)
	sw	$a2, 32($sp)
	sw	$a3, 36($sp)


	jal	Input  # Input day, month, year
	sw	$v0, 8($sp)
	
	
	addi $v0, $0, 4
	la $a0, menu
	syscall
	
	#la $a0, option
	#sw $a0,12($sp)
	
	la $a0, p_time
	lw $a1, 8($sp)
	jal Strcpy	   
	
	addi	$v0, $0, 4
	la	$a0, MENU  # Print description
	syscall


	addi $v0, $0, 4
	la $a0, option # Print a option
	syscall
	
	la $v0, 5 # read a int
	syscall
	
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, menutable
	add	$t0, $t0, $v0
	lw	$t0, 0($t0)
	jr	$t0
	
#---------------------------------------
option1: 
	lw $a0, 8($sp)
	addi $v0, $0, 4
	syscall

	j endM
#------------------------------------------------
option2:
	addi	$v0, $0, 4
	la	$a0, type
	syscall

	addi	$v0, $0, 12
	syscall
	
	lw	$a0, 8($sp)
	add	$a1, $v0, $0
	jal	Convert
	sw	$v0, ($sp)
	
	la	$a0, result
	addi	$v0, $0, 4
	syscall
	
	lw	$a0, ($sp)
	addi	$v0, $0, 4
	syscall
	

	j	endM
#-------------------------------------
option3:
	addi $v0, $0, 4
	la $a0,dateOfWeek
	syscall
	lw $a0,8($sp)
	jal weekday
	add $a0,$v0, $0
	addi $v0,$0,4
	syscall
	j endM
#-------------------------------------
option4:
	
        lw $a0,8($sp)
        jal isLeapYear
        bne $v0,1, printNotLeap
             la $a0,leap
             addi $v0, $0, 4
             syscall
             j endM
        printNotLeap:
        la $a0,notleap
        addi $v0, $0, 4
        syscall
	j endM

#-----------------------------------
option5:
	
	la $a0, p_time_1
	jal Input2
	lw $a0,8($sp)
	add $a1,$v0,$0
	jal gettime
	add $t0,$v0,$0
	
	addi $v0, $0, 4
	la $a0,distance
	syscall
	
	addi $v0,$0,1
	addi $a0,$t0,0
	syscall
	j endM
#-----------------------------------
option6:
        lw $a0,8($sp)
        jal getNextLeapYear
        addiu $sp,$sp,-8
        sw $v0,0($sp)
        sw $v1,4($sp)
        
        la $a0,nextLeapYear
        addi $v0, $0, 4
        syscall
        
        lw $v0,0($sp)
        lw $v1,4($sp)
        addiu $sp,$sp,8
        add $a0,$v0,$0
        addi $v0, $0, 1
        syscall
        
        la $a0,tab
        addi $v0, $0, 4
        syscall
        
        add $a0, $v1, $0
        addi $v0, $0, 1
        syscall
	j endM
#-----------------------------------
option7:
	la $a0, p_time_1
	jal	CheckInput  # Input day, month, 
	j endM
endM:
	# where print menu

	add  $v0, $0, $0
	
	lw 	$t0, 0($sp)
	lw	$ra, 4($sp)
	lw	$t1, 12($sp)
	lw	$t2, 16($sp)
	lw	$t3, 20($sp)
	lw	$a0, 24($sp)
	lw	$a1, 28($sp)
	lw	$a2, 32($sp)
	lw	$a3, 36($sp)
	addi	$sp, $sp, 40
	jr 	$ra
#--------------------------------------------------------------

CheckInput: 	#char* CheckInput()
	# t0 = day , t1 = month , t2 = year , t3 =dd/mm/yyyy
	addi	$sp, $sp, -40 
	sw	$ra, 36($sp)
	sw	$a0, 32($sp)
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw 	$t3, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)
	
	addi	$v0, $0, 4
	la	$a0, prompt1
	
	syscall
	
	la	$v0, 8
	la	$a0, p_day #  scanf p_day
	addi	$a1, $0, 3	
	syscall
	add	$t0, $a0, $0 # s0 = a0 

	addi	$v0, $0, 4
	la	$a0, prompt2
	syscall
	la	$v0, 8
	la	$a0, p_month # scanf p_month
	addi	$a1, $0, 3	
	syscall
	add	$t1, $a0, $0 #t1 = a0

	addi	$v0, $0, 4
	la	$a0, prompt3
	syscall
	la	$v0, 8
	la	$a0, p_year # scanf p_year
	addi	$a1, $0, 5
	syscall
	add	$t2, $a0, $0

	lw	$a3, 12($sp)

	add	$a0, $t0, $0
	jal	dayToInt
	add	$t0, $v0, $0
	
	add	$a1, $t1, $0
	jal	monthToInt
	add	$t1, $v0, $0
	
	add	$a2, $t2, $0
	jal	yearToInt
	add	$t2, $v0, $0
	
	add	$a0, $t0, $0
	add	$a1, $t1, $0
	add	$a2, $t2, $0
	
	jal	Date	
	add	$a0, $v0, $0
	add	$t3, $v0, $0
	jal Checkdate	# Check constraints

	bnez	$v0, exceptedCheck
	
	la	$a0, errorMessage
	addi	$v0, $0, 4
        syscall
        j endCheck
        
exceptedCheck:
	la	$a0, message
	addi	$v0, $0, 4
        syscall
	
endCheck:
	add	$v0, $t3, $0
	
	lw	$ra, 36($sp)
	lw	$a0, 32($sp)
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t3, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 40 
	
	jr 	$ra

#--------------------------------------------------------------
Input: 	#char* Input()
	# t0 = day , t1 = month , t2 = year , t3 =dd/mm/yyyy
	addi	$sp, $sp, -40 
	sw	$ra, 36($sp)
	sw	$a0, 32($sp)
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw 	$t3, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)
	
input_againI:
	addi	$v0, $0, 4
	la	$a0, prompt1
	syscall
	la	$v0, 8
	la	$a0, p_day #  scanf p_day
	addi	$a1, $0, 3	
	syscall
	add	$t0, $a0, $0 # s0 = a0 

	addi	$v0, $0, 4
	la	$a0, prompt2
	syscall
	la	$v0, 8
	la	$a0, p_month # scanf p_month
	addi	$a1, $0, 3	
	syscall
	add	$t1, $a0, $0 #t1 = a0


	addi	$v0, $0, 4
	la	$a0, prompt3
	syscall
	la	$v0, 8
	la	$a0, p_year # scanf p_year
	addi	$a1, $0, 5
	syscall
	add	$t2, $a0, $0

	lw	$a3, 12($sp)
	
	
	add	$a0, $t0, $0
	jal	dayToInt
	add	$t0, $v0, $0
	
	add	$a1, $t1, $0
	jal	monthToInt
	add	$t1, $v0, $0
	
	add	$a2, $t2, $0
	jal	yearToInt
	add	$t2, $v0, $0
	
	add	$a0, $t0, $0
	add	$a1, $t1, $0
	add	$a2, $t2, $0
	
	jal	Date	
	add	$a0, $v0, $0
	add	$t3, $v0, $0
	
	
	jal Checkdate	# Check constraints

	bne	$v0, $0, exceptedI
	la	$a0, errorMessage
	addi	$v0, $0, 4
	syscall
	j	input_againI

	
exceptedI:
	add	$v0, $t3, $0
	
	lw	$ra, 36($sp)
	lw	$a0, 32($sp)
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t3, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 40 
	
	jr 	$ra
#----------------------------------------------------------
#--------------------------------------------------------------
Input2: 	#char* Input2()
	# t0 = day , t1 = month , t2 = year , t3 =dd/mm/yyyy
	addi	$sp, $sp, -40 
	sw	$ra, 36($sp)
	sw	$a0, 32($sp)
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw 	$t3, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)
	
input_againI2:
	addi	$v0, $0, 4
	la	$a0, prompt1
	syscall
	la	$v0, 8
	la	$a0, tem_day #  scanf p_day
	addi	$a1, $0, 3	
	syscall
	add	$t0, $a0, $0 # s0 = a0 

	addi	$v0, $0, 4
	la	$a0, prompt2
	syscall
	la	$v0, 8
	la	$a0, tem_month # scanf p_month
	addi	$a1, $0, 3	
	syscall
	add	$t1, $a0, $0 #t1 = a0


	addi	$v0, $0, 4
	la	$a0, prompt3
	syscall
	la	$v0, 8
	la	$a0, tem_year # scanf p_year
	addi	$a1, $0, 5
	syscall
	add	$t2, $a0, $0

	lw	$a3, 12($sp)
	
	
	add	$a0, $t0, $0
	jal	dayToInt
	add	$t0, $v0, $0
	
	add	$a1, $t1, $0
	jal	monthToInt
	add	$t1, $v0, $0
	
	add	$a2, $t2, $0
	jal	yearToInt
	add	$t2, $v0, $0
	
	add	$a0, $t0, $0
	add	$a1, $t1, $0
	add	$a2, $t2, $0
	
	jal	Date	
	add	$a0, $v0, $0
	add	$t3, $v0, $0
	
	
	jal Checkdate	# Check constraints

	bne	$v0, $0, exceptedI2
	la	$a0, errorMessage
	addi	$v0, $0, 4
	syscall
	j	input_againI2

	
exceptedI2:
	add	$v0, $t3, $0
	
	lw	$ra, 36($sp)
	lw	$a0, 32($sp)
	lw	$t0, 28($sp)
	lw	$t1, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t3, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 40 
	
	jr 	$ra
#----------------------------------------------------------
Strcpy:  #char* Strcpy(char* dest, char* source )
	#a0 = destination , a1 = source
	addi 	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$t0, 0($sp)

	la	$s0, ($a0)
	la	$s1, ($a1)
loopS:
	lb 	$t0, 0($s1)
	beq	$t0, $0, endS
	sb	$t0, ($s0)
	addi	$s0, $s0, 1
	addi 	$s1, $s1, 1
	j	loopS
endS:
	
	la	$v0, ($a0)

	lw	$ra, 12($sp)
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$t0, 0($sp)
	addi 	$sp, $sp, 16

	jr 	$ra

#----------------------------------------------------------
 Date: # char* Date(int day, int month, int year, char* TIME)
	# a0 = day , a1 = month , a2 = year , a3 =dd/mm/yyyy
	addi	$sp, $sp, -32
	sw	$t2,28($sp)
	sw	$t1,24($sp)
	sw	$t0,20($sp)
	sw	$ra, 16($sp)
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$a3, 0($sp)

	addi $t0,$0,10
	div $a0,$t0
	mflo $t1
	mfhi $t2
	
	add $a0,$t1,$0
	jal intToChar
	sb $v0,0($a3)
	
	add $a0,$t2,$0
	jal intToChar
	sb $v0,1($a3)

	addi	$t0, $0, 47
	sb	$t0, 2($a3)
	
	addi $t0,$0,10
	div $a1,$t0
	mflo $t1
	mfhi $t2
	
	add $a0,$t1,$0
	jal intToChar
	sb $v0,3($a3)
	
	add $a0,$t2,$0
	jal intToChar
	sb $v0,4($a3)

	addi	$t0, $0, 47
	sb	$t0, 5($a3)

	#
	addi $t0,$0,1000
	div $a2,$t0
	mflo $t1
	mfhi $a2
	
	add $a0,$t1,$0
	jal intToChar
	sb $v0,6($a3)
	
	addi $t0,$0,100
	div $a2,$t0
	mflo $t1
	mfhi $a2
	
	add $a0,$t1,$0
	jal intToChar
	sb $v0,7($a3)
	
	addi $t0,$0,10
	div $a2,$t0
	mflo $t1
	mfhi $t2
	
	add $a0,$t1,$0
	jal intToChar
	sb $v0,8($a3)
	
	add $a0,$t2,$0
	jal intToChar
	sb $v0,9($a3)

	add	$v0, $a3, $0
	
	lw	$t2,28($sp)
	lw	$t1,24($sp)
	lw	$t0,20($sp)
	lw	$ra, 16($sp)
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 32
	
	jr	$ra
#------------------------------------------------------------
intToChar: # char so(int num)
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	addi $t0,$0,0
	beq $a0,$t0,num0
	addi $t0,$0,1
	beq $a0,$t0,num1
	addi $t0,$0,2
	beq $a0,$t0,num2
	addi $t0,$0,3
	beq $a0,$t0,num3
	addi $t0,$0,4
	beq $a0,$t0,num4
	addi $t0,$0,5
	beq $a0,$t0,num5
	addi $t0,$0,6
	beq $a0,$t0,num6
	addi $t0,$0,7
	beq $a0,$t0,num7
	addi $t0,$0,8
	beq $a0,$t0,num8
	addi $t0,$0,9
	beq $a0,$t0,num9
num0:
	addi $v0,$0,48
	j endchar
num1:
	addi $v0,$0,49
	j endchar
num2:
	addi $v0,$0,50
	j endchar
num3:
	addi $v0,$0,51
	j endchar
num4:
	addi $v0,$0,52
	j endchar
num5:
	addi $v0,$0,53
	j endchar
num6:
	addi $v0,$0,54
	j endchar
num7:
	addi $v0,$0,55
	j endchar
num8:
	addi $v0,$0,56
	j endchar
num9:
	addi $v0,$0,57
	j endchar

endchar:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
#------------------------------------------------------------
dayToInt: #  int dayToInt(char* day)
     # a0 = dd/mm/yyyy $v0 = word
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
#----------------------------------------------------------
monthToInt: #  int monthToInt(char* month)
     # a0 = dd/mm/yyyy $v0 = word
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a1)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a1)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
#------------------------------------------------------------
yearToInt:  # int yearToInt(char* year)
	# a0 = dd/mm/yyyy $v0  
     	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a2)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a2)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 2($a2)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 3($a2)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
	
	jr	$ra
#------------------------------------------------------------
Day: #  int Day(char* TIME)
     # a0 = dd/mm/yyyy $v0 = word
	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 0($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 1($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# --------------------------------------------
Month: # int Month(char* TIME)
     # a0 = dd/mm/yyyy $v0 = word
     	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 3($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 4($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra

# --------------------------------------------
Year:  # int Year(char* TIME)
	# a0 = dd/mm/yyyy $v0  
     	addi 	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$t1, 0($sp)

	lb	$t0, 6($a0)
	addi	$t0, $t0, -48 # convert char to int
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 7($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 8($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 
	
	addi	$t1, $0, 10
	mult	$t0, $t1
	mflo	$t0
	
	lb 	$t1, 9($a0)
	addi	$t1, $t1, -48 # convert char to int
	add	$t0, $t0, $t1 

	add	$v0, $t0, $0

	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$t1, 0($sp)
	addi 	$sp, $sp, 12
	
	jr	$ra
	
	jr	$ra
#------------------------------------------------------------------

#---------------------------------------------------------------------

Checkdate: # int Checkdate(char* TIME)
	addi	$sp, $sp, -32
	sw	$a0, 28($sp)
	sw	$ra, 24($sp)
	sw	$t0, 20($sp)
	sw	$t1, 16($sp)
	sw	$t2, 12($sp)
	sw	$t3, 8($sp)
	sw	$t4, 4($sp)
	sw	$s0, 0($sp)
	
	lw	$a0, 28($sp)
	jal	Day
	add	$t0, $v0, $0
	
	lw 	$a0, 28($sp)
	jal	Month
	add	$t1, $v0, $0
	
	lw 	$a0, 28($sp)
	jal	Year
	add	$t2, $v0, $0
		
 
	addi $t3, $0, 12
	bgt $t1, $t3, falseC # Check constraint month
	bltz $t1,falseC 
	
	la	$s0, daysOfMonth
	addi	$t3, $t1, 0
	sll	$t3, $t3, 2
	add	$s0, $s0, $t3
	lw	$t3, ($s0)    # t3 = daysOfmonth[t1] 
	
	
	blez $t0,falseC 
	
	lw $a0, 28($sp)
	jal isLeapYear
	beqz $v0, februaryF  # ferb
	
	addi $t1,$t1,-2      #Is February
	bnez $t1, februaryF
	
	addi $t3, $t3, 1
februaryF:
	bgt $t0, $t3, falseC # Check constraint day
	
trueC:
	addi $v0, $0, 1
	j endC
falseC:
	addi $v0, $0, 0
endC:
	lw	$a0, 28($sp)
	lw	$ra, 24($sp)
	lw	$t0, 20($sp)
	lw	$t1, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 32

	jr 	$ra

#-----------------------------------------------------------------
# For option 2
#----------------------------------------------------------------
# -----------------------------------------------------------
Convert: #char* Convert(char* time, char type)
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$t0, 12($sp)
	sw	$t1, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)

	addi	$t0, $0, 65
	bne 	$a1, 65, typeB

	# s0 = 'MM'
	la	$s0, p_month
	
	lb	$t0, 3($a0)
	sb	$t0, ($s0)

	lb	$t0, 4($a0)
	sb	$t0, 1($s0)

	# s1 = 'DD'
	la	$s1, p_day
	
	lb	$t0, ($a0)
	sb	$t0, ($s1)

	lb	$t0, 1($a0)
	sb	$t0, 1($s1)


	# $a0 = strcpy($a0, $s0)
	la 	$a1, ($s0)
	jal 	Strcpy
	add 	$a0, $v0, $0
	la	$a0, 3($a0)

	# $a0 = strcpy($a0, $s1)
	la 	$a1, ($s1)
	jal 	Strcpy
	la 	$a0, -3($v0)
	j 	endConvert

typeB:
	bne 	$a1, 66, typeC

	jal Month
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, nameOfMonth
	add	$t0, $t0, $v0
	lw	$t0, ($t0)
	
	add $a1, $t0, $0  # Copy month
	jal Strcpy
	
	addi	$t0, $0, 32	# space
	sb	$t0, 3($a0)
	
	la	$t0, p_day
	la	$a0, 4($a0)
	add 	$a1, $t0, $0
	jal	Strcpy
	la	$a0, -4($v0) 
	
	addi	$t0, $0, 44	# ,
	sb	$t0, 6($a0)
	addi	$t0, $0, 32	# space
	sb	$t0, 7($a0)
	
	la 	$t1, p_year
	la	$a0, 8($a0)
	add 	$a1, $t1, $0
	jal	Strcpy
	la	$a0, -8($v0) 
	
	addi	$t0, $0, 0	# \0
	sb	$t0, 12($a0)
	
	j 	endConvert

typeC:
	
	la	$t0, p_day
	add 	$a1, $t0, $0
	jal	Strcpy
	
	addi	$t0, $0, 32	# space
	sb	$t0, 2($a0)
	
	jal Month
	addi	$v0, $v0, -1
	sll	$v0, $v0, 2
	la	$t0, nameOfMonth
	add	$t0, $t0, $v0
	lw	$t0, ($t0)
	
	la $a0, 3($a0)
	add $a1, $t0, $0  # Copy month
	jal Strcpy
	la $a0, -3($a0)
	

	addi	$t0, $0, 44	# ,
	sb	$t0, 6($a0)
	addi	$t0, $0, 32	# space
	sb	$t0, 7($a0)
	
	la 	$t1, p_year
	la	$a0, 8($a0)
	add 	$a1, $t1, $0
	jal	Strcpy
	la	$a0, -8($v0) 
	
	addi	$t0, $0, 0	# \0
	sb	$t0, 12($a0)
	

endConvert:
	
	add	$v0, $a0, $0
	lw	$ra, 16($sp)
	lw	$t0, 12($sp)
	lw	$t1, 8($sp)
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addi	$sp, $sp, 20

	jr 	$ra


#-------------------------------------------------------------
#for option 3
#-------------------------------------------------------------
#-------------------------------------------------------------
weekday: #char * weekday(char *time)
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	

	lw $a0,4($sp)
	jal Day
	add $t0,$v0,$0 #day

	lw $a0,4($sp)
	jal Month
	add $t1,$v0,$0 #month


	lw $a0,4($sp)
	jal Year
	add $t2,$v0,$0 #year

	addi $t4,$t2,-1
	addi $t3,$0,4
	div $t4,$t3
	mflo $t3

	addi $t4,$0,365
	mult $t2,$t4
	mflo $v0
	add $v0,$v0,$t3
	
	addi $t4,$0,2
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,3
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	sw $v0,24($sp)
	lw $a0,4($sp)
	jal isLeapYear
	add $a0,$v0,$0
	lw $v0,24($sp)
	beq $a0,$0,step1
	addi $v0,$v0,1
step1:
	addi $v0,$v0,28
	addi $t4,$0,4
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,5
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,6
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,7
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,8
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,9
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,10
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,30
	addi $t4,$0,11
	slt $t4,$t1,$t4
	bne $t4,$0,wkd
	addi $v0,$v0,31
	addi $t4,$0,12
	bne $t1,$t4,wkd
	addi $v0,$v0,30

wkd:
	add $v0,$t0,$v0
	addi $t4,$0,7
	addi $v0,$v0,-2
	div $v0,$t4
	mfhi $a0
	#add $a0,$v0,$0
	jal printweekday
	
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,28
	
	jr $ra	


#----------------------------------------------------------------
printweekday: #void printweekday(int day)
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t0,8($sp)

	addi $t0,$0,0
	beq $a0,$t0,sunday	
	addi $t0,$0,1
	beq $a0,$t0,monday
	addi $t0,$0,2
	beq $a0,$t0,tuesday
	addi $t0,$0,3
	beq $a0,$t0,wedday
	addi $t0,$0,4
	beq $a0,$t0,thursday
	addi $t0,$0,5
	beq $a0,$t0,friday
	addi $t0,$0,6
	beq $a0,$t0,satday
sunday:
	la $a0,sun
	j endpwd
monday:
	la $a0,mon
	j endpwd
tuesday:
	la $a0,tues
	j endpwd
wedday: 
	la $a0,wed
	j endpwd
thursday:
	la $a0,thurs
	j endpwd
friday:
	la $a0,fri
	j endpwd
satday:
	la $a0,sat
	j endpwd
endpwd:
	add $v0, $a0, $0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t0,8($sp)
	addi $sp,$sp,12
	
	jr $ra
#--------------------------------------------------------
#for option 4
isLeapYear:
addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$a0, 0($sp)
	
	
	jal	Year
	add	$a0, $v0, $0
	
	
	addi	$t0, $0, 400
	div	$a0, $t0
	mfhi	$t0
	beqz 	$t0, trueL	# type 400*k , 400, 2000
	
	addi	$t0, $0, 4
	div	$a0, $t0
	mfhi	$t0
	bnez 	$t0, falseL	# type !4*k	2, 1903
	
	addi	$t0, $0, 100
	div	$a0, $t0
	mfhi	$t0
	bnez	$t0, trueL  # type 1904 type 4*k % 100 != 0
	beqz 	$t0, falseL 
		
trueL:
	addi	$v0, $0,1
	j	endL
falseL:
	addi	$v0, $0,0
endL:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$a0, 0($sp)	
	addi	$sp, $sp, 12

	jr	$ra
#--------------------------------------------------------
#for option 5
#--------------------------------------------------------

dayoder: #int dayoderinyear(char *time)
	
	
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	sw $t0,24($sp)

	lw $a0,4($sp)
	jal Day
	add $t0,$v0,$0 #day

	lw $a0,4($sp)
	jal Month
	add $t1,$v0,$0 #month


	lw $a0,4($sp)
	jal Year
	add $t2,$v0,$0 #year

	add $v0,$0,$0
	
	addi $t4,$0,2
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,3
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	sw $v0,24($sp)
	lw $a0,4($sp)
	jal isLeapYear
	add $a0,$v0,$0
	lw $v0,24($sp)
	beq $a0,$0,step2
	addi $v0,$v0,1
step2:
	addi $v0,$v0,28
	addi $t4,$0,4
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,5
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,6
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,7
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,8
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,9
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,10
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,30
	addi $t4,$0,11
	slt $t4,$t1,$t4
	bne $t4,$0,doiy
	addi $v0,$v0,31
	addi $t4,$0,12
	bne $t1,$t4,doiy
	addi $v0,$v0,30

doiy:
	add $v0,$t0,$v0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	lw $t0,24($sp)
	addi $sp,$sp,28
	
	jr $ra
#-----------------------------------------------------
gettime: #int gettime(char *time1,char *time2)
	addi $sp,$sp,-32
	sw $a0,0($sp)
	sw $a1,4($sp)
	sw $t0,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)
	sw $t4,24($sp)
	sw $ra,28($sp)
	
	la $a0,endline
	addi $v0,$0,4
	syscall	

	lw $a0,0($sp)
	jal dayoder
	add $t0,$v0,$0
	

	lw $a0,4($sp)
	jal dayoder
	add $t1,$v0,$0

	lw $a0,0($sp)
	jal Year
	add $t2,$v0,$0
	
	lw $a0,4($sp)
	jal Year
	add $t3,$v0,$0
	
	add $a0,$t2,$0
	add $a1,$t3,$0
	jal exleapyear
	add $a1,$v0,$0

	slt $t4,$t3,$t2
	beq $t4,$0,smaller
	addi $t4,$0,365
	sub $v0,$t2,$t3
	mult $v0,$t4
	mflo $v0
	sub $v0,$v0,$t1
	add $v0,$v0,$t0
	j endgt
smaller:
	beq $t2,$t3,equal
	addi $t4,$0,365
	sub $v0,$t3,$t2
	mult $v0,$t4
	mflo $v0
	sub $v0,$v0,$t0
	add $v0,$v0,$t1
	j endgt
equal:
	slt $t4,$t0,$t1
	bne $t4,$0,smaller1
	sub $v0,$t0,$t1
	j endgt
smaller1:
	sub $v0,$t1,$t0
endgt:

	addi $t4,$0,365
	add $v0,$a1,$v0
	div $v0,$t4
	mflo $v0
	
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $t0,8($sp)
	lw $t1,12($sp)
	lw $t2,16($sp)
	lw $t3,20($sp)
	lw $t4,24($sp)
	lw $ra,28($sp)
	addi $sp,$sp,32
	
	jr $ra
#-----------------------------------------------------
leapyear1: #int leapyear(int year)
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$t0, 4($sp)
	sw	$a0, 0($sp)
	
	
	addi	$t0, $0, 400
	div	$a0, $t0
	mfhi	$t0
	beqz 	$t0, trueL1	# type 400*k , 400, 2000
	
	addi	$t0, $0, 4
	div	$a0, $t0
	mfhi	$t0
	bnez 	$t0, falseL1	# type !4*k	2, 1903
	
	addi	$t0, $0, 100
	div	$a0, $t0
	mfhi	$t0
	bnez	$t0, trueL1# type 1904 type 4*k % 100 != 0
	beqz 	$t0, falseL1 
		
trueL1:
	addi	$v0, $0,1
	j	endL1
falseL1:
	addi	$v0, $0,0
endL1:
	lw	$ra, 8($sp)
	lw	$t0, 4($sp)
	lw	$a0, 0($sp)	
	addi	$sp, $sp, 12

	jr	$ra
#-----------------------------------------------------
exleapyear: #int exleapyear(int year1,int year2)
	addi $sp,$sp,-28
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t2,20($sp)
	sw $t3,24($sp)
		


	add $t3,$0,$0
	slt $t0,$a0,$a1
	beq $t0,$0,exl1
	add $t0,$a0,$0
	add $t1,$a1,$0
	j calexly
exl1:
	add $t0,$a1,$0
	add $t1,$a0,$0
calexly:
	slt $t2,$t0,$t1
	beq $t2,$0,endexly
	
	add $a0,$t0,$0
	jal leapyear1
	beq $v0,$0,nly
	addi $t3,$t3,1
nly:
	addi $t0,$t0,1
	j calexly
endexly:
	
	add $v0,$t3,$0
	
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	addi $sp,$sp,28

	jr $ra
#----------------------------------------------------------------
#For option 6
#-----------------------------------------------------------------
getNextLeapYear:
     addiu $sp,$sp,-8
     sw $a0,0($sp)
     sw $ra,4($sp)
     jal Year
     add $t1, $v0, $0
     add $t4,$v0,$zero
     
     lw $a0,0($sp)
     lw $ra,4($sp)
     jal Day
     add $t5, $v0, $0
     
     lw $a0,0($sp)
     lw $ra,4($sp)
     jal Month
     lw $ra,4($sp)
     lw $a0,0($sp)
     addiu $sp,$sp,8
     add $t6, $v0, $0
    
     
    whileLoop1:
         addi 	$t1,$t1,1   
         add 	$a2, $t1, $0
         addiu 	$sp,$sp,-8
         sw 	$t1,0($sp)
         sw 	$ra,4($sp)
        
         add    $a0,$t5,$zero
         add    $a1,$t6,$zero
         la     $a3,p_time_1
         jal    Date
         add    $a3,$v0,$zero
         add    $a0,$a3,0
         jal     isLeapYear
       
         add 	$t2,$v0,$zero
         beq 	$t2,1,endWhile1
         lw 	$t1,0($sp)
         lw 	$ra,4($sp)
         addiu	$sp,$sp,8
         j whileLoop1
     endWhile1:
       lw $t1,0($sp)
       lw $ra,4($sp)
       addiu $sp,$sp,8
      
     add $t2,$t4,$0
      
     whileLoop2:
         addi 	$t2,$t2,-1   
         add 	$a2, $t2, $0
         addiu 	$sp,$sp,-8
         sw 	$t2,0($sp)
         sw 	$ra,4($sp)
        
         add    $a0,$t5,$zero
         add    $a1,$t6,$zero
         la     $a3,p_time_1
         jal    Date
         add    $a3,$v0,$zero
         add    $a0,$a3,0
         jal     isLeapYear
       
         add 	$t3,$v0,$zero
         beq 	$t3,1,end
         lw 	$t2,0($sp)
         lw 	$ra,4($sp)
         addiu	$sp,$sp,8
         j whileLoop2
      
    end:
       lw $ra,4($sp)
       addiu $sp,$sp,8
       add $v0, $t2, $0
       add $v1, $t1, $0
       jr $ra
