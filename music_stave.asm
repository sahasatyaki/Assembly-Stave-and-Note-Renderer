.data

OnScreenLabel1: .asciiz "Options:\t Colors: \n1 - cls \t 1 - Red \n2 - stave \t 2 - Green \n3 - note \t 3 - Orange \n4 - exit \t 4 - Violet\n\n"     # OPTIONS FOR OPERATIONS

prompt: .asciiz " Enter your Choice for Operations: "

color_prompt: .asciiz " \n Enter Your Choice for Colour/Row/Note:  "

ReserveSpace:

.space 0x80000 # RESERVES THE SPACE

.text

start_menu:

addi $v0, $zero, 4                                                                        # 4 - NUMBER CORRESPONDING TO asciiz or string | 5 - TO TAKE INPUT FROM THE USER                                                                

la $a0, OnScreenLabel1                                                                    # LOADING THE VALUES OF ' OnScreenLabel1 ' TO $a0 REGISTER  
                                                                   
syscall                                                                                   # TO PRINT THE VALUE(S) IN REGISTER $a0

li $v0, 4

la $a0, prompt
syscall

li $v0, 5                                                                        # TAKING THE INPUT FROM THE USER 

syscall                                                                                   # DISPLAYING THE INPUT TAKEN FROM THE USER ON SCREEN



# THIS PART IS FOR IF THE INPUT MATCHES THE OPTION, GIVE ANOTHER SET OF OPTIONS FOR CHOOSING THE BACKGROUND COLOR

Color_menu:


beq $v0, 1, numberEqual                                                                   # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (1 --> cls) THEN PERFORM THE ACTION IN THE ' numberEqual ' LABEL
beq $v0, 2, numberEqual1                                                                  # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (2 --> stave) THEN PERFORM THE ACTION IN THE ' numberEqual1 ' LABEL
beq $v0, 3, numberEqual2                                                                  # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (3 --> note) THEN PERFORM THE ACTION IN THE ' numberEqual2 ' LABEL
beq $v0, 4, numberEqual3                                                                  # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (4 --> exit) THEN PERFORM THE ACTION IN THE ' numberEqual3 ' LABEL
li $v0, 10                                                                                # TERMINATE AFTER THIS, OTHERWISE THE LABELS WOULD RUN ANYWAYS
syscall

# ---------------------------------------------------------------------------- BACKGROUND ------------------------------------------------------------------------------------------------------------------- #

numberEqual:                                                                              # IF THE NUMBERS ARE EQUAL  

li $v0, 4                                                                                 # GET READY TO PRINT AN STRING

la $a0, color_prompt                                                                      # LOADING THE VALUE OF " color_prompt " TO $t1 REGISTER

syscall                                                                                   # PRINTING THE RESULT IN $t1 REGISTER

li $v0, 5
syscall 

beq $v0, 1, Red   # IF THE USER - INPUT IS 1 ----> GO TO Red AND PERFORM THE ACTION
beq $v0, 2, Green # IF THE USER - INPUT IS 2 ----> GO TO Green AND PERFORM THE ACTION
beq $v0, 3, Orange # IF THE USER - INPUT IS 3 ----> GO TO Orange AND PERFORM THE ACTION
beq $v0, 4, Violet # IF THE USER - INPUT IS 4 ----> GO TO Violet AND PERFORM THE ACTION

Red:

lui $s0, 0x1004

lui $s1, 0x100c

add $t2, $zero, $s0 

background:

addi $t1, $zero, 0xff0000
sw $t1, 0($t2)

addi $t2, $t2, 4
bne $t2, $s1, background

j start_menu # OVER HERE, I DONOT WANT TO TERMINATE THE PROGRA, RATHER I WANT TO JUM TO THE START MENU SO THAT THE USER CAN PERFORM MORE OPERATIONS

Green:

lui $s0, 0x1004
lui $s1, 0x100c

add $t2, $zero, $s0 

background1:

addi $t3, $zero, 0x00ff00
sw $t3, 0($t2)

addi $t2, $t2, 4
bne $t2, $s1, background1


j start_menu # OVER HERE, I DONOT WANT TO TERMINATE THE PROGRAM RIGHT AFTER FILLING THE BACKGROUND, RATHER I WANT TO JUMP TO THE START MENU SO THAT THE USER CAN PERFORM MORE OPERATIONS

Orange:

lui $s0, 0x1004

lui $s1, 0x100c

add $t2, $zero, $s0 

background2:

addi $t4, $zero, 0xff8c00

sw $t4, 0($t2)

addi $t2, $t2, 4
bne $t2, $s1, background2


j start_menu # OVER HERE, I DONOT WANT TO TERMINATE THE PROGRAM RIGHT AFTER FILLING THE BACKGROUND, RATHER I WANT TO JUMP TO THE START MENU SO THAT THE USER CAN PERFORM MORE OPERATIONS

Violet:

lui $s0, 0x1004

lui $s1, 0x100c

add $t2, $zero, $s0 

background3:

addi $t5, $zero, 0x9400d3

sw $t5, 0($t2)

addi $t2, $t2, 4
bne $t2, $s1, background3

j start_menu # OVER HERE, I DONOT WANT TO TERMINATE THE PROGRAM RIGHT AFTER FILLING THE BACKGROUND, RATHER I WANT TO JUMP TO THE START MENU SO THAT THE USER CAN PERFORM MORE OPERATIONS

# --------------------------------------------------------------------------- END OF BACKGROUND ------------------------------------------------------------------- #

# --------------------------------------------------------------------------------- STAVE ------------------------------------------------------------------------------- #

numberEqual1:

li $v0, 4
la $a0, color_prompt

syscall

li $v0, 5
syscall


    #----------------------------------------------------------------- ROW CONVERSION ACCORDING TO INPUT BY THE USER -----------------------------------#

addi $s0, $zero, 2048
add $s1, $zero, $v0
add $s6, $zero,$v0
mul $t7, $s0, $s1

# ---------------------------------------------------------------------- USING THE CONVERTED ROW --------------------------------------------------------- #

Procedure:

li $s3, 0x10040000 # STARTING POINT

add $t3, $t7, $s3 # HERE, I AM JUST ADDING THE USER-INPUT ROW NUMBER WITH THE STARTING POINT TO SPECIFY THE STARTING POINT FROM WHICH THE HORIZONTAL LINES START DRAWING.
addi $a0, $zero, 0xFFFFFF # COLOUR OF THE HORIZONTAL LINES ( WHITE IN THIS CASE )
addi $t0, $zero, 5 # NUMBER OF HORIZONTAL LINES
addi $t1, $zero, 0 # WE INITIALIZE A COUNTER THAT COUNTS THE NUMBER OF LINES
addi $s1, $t3, 2048 # VERTICALLY INCREMENT THE LINES

stave:

beq $t1, $t0, start_menu # IF THE NUMBER OF LINES SATISFY END THE LOOP

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

# -------------------------------------------------------------------- END OF STAVE -------------------------------------------------------------------------------------------------- #

# ----------------------------------------------------------------------- NOTES --------------------------------------------------------------------------------------------------------- #

numberEqual2:
li $v0, 4
la $a0, color_prompt

syscall

li $v0, 12
syscall

li $a2, 8 # WIDTH = 8
li $a1, 96 # TOP Y - COORDINATE = 200
li $t0, 6 # HEIGHT = 6
add $a1, $a1, $s6

beq $v0, 65, A # IF THE INPUT RECIEVED IS 65 ( ASCII OF A ), THEN GO TO BRANCH ----> A | NOTE:  65 ----> A
beq $v0, 66, B # IF THE INPUT RECIEVED IS 66 ( ASCII OF B ), THEN GO TO BRANCH ----> B | NOTE:  66 ----> B
beq $v0, 67, C # IF THE INPUT RECIEVED IS 67 ( ASCII OF C ), THEN GO TO BRANCH ----> C | NOTE:  67 ----> C
beq $v0, 68, D # IF THE INPUT RECIEVED IS 68 ( ASCII OF D ), THEN GO TO BRANCH ----> D | NOTE:  68 ----> D
beq $v0, 69, E # IF THE INPUT RECIEVED IS 69 ( ASCII OF E ), THEN GO TO BRANCH ----> E | NOTE:  69 ----> E
beq $v0, 70, F # IF THE INPUT RECIEVED IS 70 ( ASCII OF F ), THEN GO TO BRANCH ----> F | NOTE:  70 ----> F
beq $v0, 71, G # IF THE INPUT RECIEVED IS 71 ( ASCII OF G ), THEN GO TO BRANCH ----> G | NOTE:  71 ----> G

li $v0, 10 # TERMINATE AFTER THIS, BASICALLY DO NOT PERFORM FURTHER ACTION UNLESS NOT SPECIFIED             
syscall

A:
addi $a1, $a1, 25
li $a3, 90 # X - COORDINATE = 90
la $a0, 69 # PITCH OF NOTE ----> A
j rectangle1

B:
addi $a1, $a1, 19
li $a3, 110 # X - COORDINATE = 110
la $a0, 71 # PITCH OF NOTE ----> B
j rectangle1

C:
addi $a1, $a1, 14
li $a3, 160 # X - COORDINATE = 160
la $a0, 72 # PITCH OF NOTE ----> C
j rectangle1

D:
addi $a1, $a1, 8
li $a3, 190 # X - COORDINATE = 190
la $a0, 74 # PITCH OF NOTE ----> D
j rectangle1

E:
addi $a1, $a1, 3
li $a3, 210 # X - COORDINATE = 210
la $a0, 76 # PITCH OF NOTE ----> E
j rectangle1

F:
addi $a1, $a1, 36
li $a3, 10 # X - COORDINATE = 10
la $a0, 65 # PITCH OF NOTE ----> F
j rectangle1

G:
addi $a1, $a1, 30
li $a3, 60 # X - COORDINATE = 60
la $a0, 67 # PITCH OF NOTE ----> G
j rectangle1 # j - JUMP TO rectangle1

li $v0, 10 # TERMINATE AFTER THIS, BASICALLY DO NOT PERFORM FURTHER ACTION UNLESS NOT SPECIFIED
syscall

rectangle1: # PROCEDURE

#------------------------------------------------------------------- DRAWING THE NOTES -------------------------------------------------------#

li $t9, 0x000000 # LOAD/STORE THE COLOR OF THE NOTES ( BLACK IN THIS CASE )
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
bne $a1, $t0, YAxisLoop # CONTINUE YAxisLoop TILL THE BASE

li $v0, 33


addi $a1, $zero, 1000 # DURATION
addi $a2, $zero, 7 # INSTRUMENT
addi $a3, $zero, 100 # VOLUME

syscall

j start_menu # SO THAT IT GOES TO THE start_menu AND RUNS EVERYTHING FROM THE BEGINNIG

# ----------------------------------------------------------------- END OF NOTES -------------------------------------------------------------------------------------------------------------------------------------- #

# --------------------------------------------------------------------- EXIT ---------------------------------------------------------------------------------------------------------------------------------------------- #

numberEqual3:


li $v0, 10 # TERMINATE
syscall

# --------------------------------------------------------------- END OF THE PROGRAM --------------------------------------------------------------------------------------------------------------------------------- #
