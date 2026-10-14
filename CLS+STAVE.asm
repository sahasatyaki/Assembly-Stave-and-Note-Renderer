.data

OnScreenLabel1: .asciiz "Options:\t Colors: \n1 - cls \t 1 - Red \n2 - stave \t 2 - Green \n3 - note \t 3 - Orange \n4 - exit \t 4 - Violet\n\n"     # OPTIONS FOR OPERATIONS

prompt: .asciiz " Enter your Choice for Operations: "

color_prompt: .asciiz " \n Enter Your Choice for Colour/Row/Note:   "

notes_data: .word 0x1c00, 0x4400, 0x7c00, 0x9c00, 0xcc00, 0xf400, 0x12400

#                    E       D       C       B       A       G        F 
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
beq $v0, 2, numberEqual1                                                                  # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (2 --> stave) THEN PERFORM THE ACTION IN THE ' numberEqual2 ' LABEL
beq $v0, 3, numberEqual2                                                                  # IF THE USER-INPUT MATCHES THIS COPY OF THE OPTION (3 --> note) THEN PERFORM THE ACTION IN THE ' numberEqual3 ' LABEL
li $v0, 10                                                                                # TERMINATE AFTER THIS, OTHERWISE THE LABEL " numberEqual " WOULD RUN ANYWAYS
syscall


numberEqual:                                                                              # IF THE NUMBERS ARE EQUAL  

li $v0, 4                                                                                 # GET READY TO PRINT AN STRING

la $a0, color_prompt                                                                      # LOADING THE VALUE OF " color_prompt " TO $t1 REGISTER

syscall                                                                                   # PRINTING THE RESULT IN $t1 REGISTER

li $v0, 5
syscall 

beq $v0, 1, Red
beq $v0, 2, Green
beq $v0, 3, Orange
beq $v0, 4, Violet

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

# ------------------------------------------------------------------------------------------------ STAVE ------------------------------------------------------------------------------- #

numberEqual1:

li $v0, 4
la $a0, color_prompt

syscall

li $v0, 5
syscall


#---------------------------------------------------------------------------------------------------- ROW CONVERSION ACCORDING TO INPUT BY THE USER -----------------------------------#

addi $s0, $zero, 2048
add $s1, $zero, $v0

mul $t7, $s0, $s1

# ---------------------------------------------------------------------------------------------------- USING THE CONVERTED ROW --------------------------------------------------------- #

Procedure:

li $s3, 0x10040000 # STARTING POINT

add $t3, $t7, $s3 # HERE, I AM JUST ADDING THE USER-INPUT ROW NUMBER WITH THE STARTING POINT TO SPECIFY THE STARTING POINT FROM WHICH THE HORIZONTAL LINES START DRAWING.
addi $a0, $zero, 0x00ff # COLOUR OF THE HORIZONTAL LINES
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

# ----------------------------------------------------------------------- END OF STAVE -------------------------------------------------------------------------------------------------- #

# ----------------------------------------------------------------------- NOTES --------------------------------------------------------------------------------------------------------- #

numberEqual2:

li $v0, 4
la $a0, color_prompt

syscall

li $v0, 5
syscall


