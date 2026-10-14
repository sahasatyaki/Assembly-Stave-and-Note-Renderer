.data

prompt: .asciiz " Enter the number of gaps:  "

.text

#--------------------------------------------------------------------------------------------------- USER-INPUT -----------------------------------------------------------------------#

li $v0, 4
la $a0, prompt
syscall
li $v0, 5
syscall

#---------------------------------------------------------------------------------------------------- ROW CONVERSION ACCORDING TO INPUT BY THE USER -----------------------------------#

addi $s0, $zero, 2048
add $s1, $zero, $v0

mul $t7, $s0, $s1

jal Procedure

li $v0, 10
syscall
#---------------------------------------------------------------------------------------------------- USING THE CONVERTED ROW ---------------------------------------------------------#

Procedure:

li $s0, 0x10045000 # STARTING POINT

add $t3, $t7, $s0 # HERE, I AM JUST ADDING THE USER-INPUT ROW NUMBER WITH THE STARTING POINT TO SPECIFY THE STARTING POINT FROM WHICH THE HORIZONTAL LINES START DRAWING.
addi $a0, $zero, 0x00ff # COLOUR OF THE HORIZONTAL LINES
addi $t0, $zero, 5 # NUMBER OF HORIZONTAL LINES
addi $t1, $zero, 0 # WE INITIALIZE A COUNTER THAT COUNTS THE NUMBER OF LINES
addi $s1, $t3, 2048 # VERTICALLY INCREMENT THE LINES

stave:

beq $t1, $t0, exit # IF THE NUMBER OF LINES SATISFY END THE LOOP

beq $t3, $s1, blankLineCounter # IF THE NUMBER OF LINES ARE EQUAL, GO TO THE ' exit ' LABLE, AND PERFORM IT'S ACTION.

# IN ORDER TO DRAW WE FOLLOW THE SOME WHAT SAME RULE AS DRAWING THE BACKGROUND
sw $a0, 0($t3)
addi $t3, $t3, 4
j stave

blankLineCounter:

addi $t3, $t3, 20480 # I NEED 10 BLANK LINES IN THE MIDDLE OF EACH LINE
addi $s1, $t3, 2048 # AND, WE LEAVE 10 SPACES VERTICALLY
addi $t1, $t1, 1 # WE INCREMENT THE COUNTER BY 1 AFTER DRAWING EACH LINE

j stave

exit:
jr $ra

