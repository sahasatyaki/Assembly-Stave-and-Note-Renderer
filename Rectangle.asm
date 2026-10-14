.data

ReserveSpace:

.space 0x80000

color_prompt: .asciiz " \n Enter Your Choice for Colour/Row/Note:   "

.text
li $v0, 4
la $a0, color_prompt

syscall
li $v0, 12
syscall

li $a2, 8 # WIDTH = 8
li $a1, 96 # TOP Y - COORDINATE = 200
li $t0, 6 # HEIGHT = 6

beq $v0, 65, A
beq $v0, 66, B
beq $v0, 67, C
beq $v0, 68, D
beq $v0, 69, E
beq $v0, 70, F
beq $v0, 71, G
li $v0, 10                     
syscall
A:
addi $a1, $a1, 25
li $a3, 90 # LEFT X - COORDINATE = 90
la $a0, 69
j rectangle1

B:
addi $a1, $a1, 19
li $a3, 110 # LEFT X - COORDINATE = 110
la $a0, 71
j rectangle1

C:
addi $a1, $a1, 14
li $a3, 160 # LEFT X - COORDINATE = 160
la $a0, 72
j rectangle1

D:
addi $a1, $a1, 8
li $a3, 190 # LEFT X - COORDINATE = 150
la $a0, 74
j rectangle1

E:
addi $a1, $a1, 3
li $a3, 210 # LEFT X - COORDINATE = 170
la $a0, 76
j rectangle1

F:
addi $a1, $a1, 36
li $a3, 10 # LEFT X - COORDINATE = 100
la $a0, 65
j rectangle1

G:
addi $a1, $a1, 30
li $a3, 60 # LEFT X - COORDINATE = 100
la $a0, 67
j rectangle1

j rectangle1 # j - JUMP TO rectangle1

li $v0, 10 # TERMINATE AFTER THIS, BASICALLY DO NOT PERFORM FURTHER ACTION UNLESS NOT SATISFIES
syscall

rectangle1: # PROCEDURE

#------------------------------------------------------------------- DO NOTHING -------------------------------------------------------#

# IF MY HEIGHT ($a0) AND WIDTH ($a2) ARE 0, DO NOT DRAW ANYTHING (GO TO RectangleReturn)
 
beq $a2, $zero, RectangleReturn
beq $a1, $zero, RectangleReturn

#------------------------------------------------------------------- DO NOTHING -------------------------------------------------------#

#------------------------------------------------------------------- DO SOMETHING -------------------------------------------------------#

li $t9, 0xffffff # LOAD/STORE THE COLOR
la $t8, ReserveSpace # LOAD THE SPACE RESERVED

# -------------------------------------------------- MAKING LOOP TEST EASY BY SWITCHING TO THE FURTHEST VALUE OF THE RECTANGLE -------------------------------------------- #

add $a2, $a2, $a3 
add $t0, $t0, $a1

# -------------------------------------------------- MAKING LOOP TEST EASY BY SWITCHING TO THE FURTHEST VALUE OF THE RECTANGLE -------------------------------------------- #

# -------------------------------------------------- SHIFTING X - VALUES (4 BYTES PER PIXEL) ------------------------------------------------------------------------------ #

sll $a3, $a3, 2
sll $a2, $a2, 2

# -------------------------------------------------- SHIFTING Y - VALUES (512 X 4 BYTES PER ROWS OF THE DISPLAY) ------------------------------------------------------------------------------ #

sll $a1, $a1, 11
sll $t0, $t0, 11

# -------------------------------------------------- CONVERTING Y - VALUES TO DETERMINE DISPLAY ROW STARTING ADDRESS ------------------------------------------------------------------------------ #

add $t7, $a1, $t8
add $t0, $t0, $t8 

# -------------------------------------------------- CONVERTING Y - VALUES TO DETERMINE RECTANGLE ROW STARTING ADDRESS ------------------------------------------------------------------------------ #

add $a1, $t7, $a3
add $t0, $t0, $a3

add $t7, $t7, $a2 # ENDING ADDRESS FOR FIRST RECTANGULAR ROW

li $t6, 0x800 # STORING THE BYTES PER DISPLAY ROW

YAxisLoop:

move $t5, $a1 # CREATING A COPY OF $a1 in $t5 | INDICATOR TO CURRENT PIXEL FOR X LOOP, STARTING AT THE LEFT MST EDGE

XAxisLoop:

sw $t9, ($t5) # TAKE THE SPECIFIED COLOUR AND START DRAWING FROM THE SPECIFIED PIXEL
add $t5, $t5, 4
bne $t5, $t7, XAxisLoop # CONTINUE THE XAxisLoop IF THE RIGHT-EDGE OF THE RECTANGLE IS NOT FINISHED
add $a1, $a1, $t6 # INCREMENT BY ONE ROW FOR LEFT-EDGE
add $t7, $t7, $t6 # INCREMENT BY ONE ROW FOR RIGHT-EDGE
bne $a1, $t0, YAxisLoop # CONTINUE YAxisLoop TILL THE RECTANGLE'S BASE

li $v0, 33


addi $a1, $zero, 1000
addi $a2, $zero, 7
addi $a3, $zero, 100

syscall

RectangleReturn: # JUMP TO START



