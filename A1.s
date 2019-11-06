.data

arrayA:	.word 1,1,1,1
        .word 1,2,2,2
        .word 1,2,2,2
        .word 1,2,2,2

arrayB:	.word 1,1,1,1
        .word 1,3,3,3
        .word 1,2,3,3
        .word 1,3,3,2

final:	.word 0,0,0,0
        .word 0,0,0,0
        .word 0,0,0,0
        .word 0,0,0,0

N:      .word 4

size:   .word 128

      .text
main:
daddi R1, $zero, N #Variable's "N" base
daddi R2, $zero, arrayA #Array's "A" base

daddi R6, $zero, arrayB #Array's "B" base


daddi R5, $zero, 8 #R5 = i / γραμμές !δεν υπολογίζουμε την πρώτη γραμμή

lw    R1, 0(R1) # Load the size of dimension
dsll R7,R1,3    # Calculate the Number of Elements
daddi R2, R2, 32 # Skipping first line for A
daddi R6, R6, 32 # Skipping first line for Β


Loop1:

  daddi R4, $zero, 8 # R4 = j / οι στύλες !δεν υπολογίζουμε την πρώτη στήλη

  Loop:
      daddi R2,R2,8 # +1 θέση μνήμης οπού R2 έχει την θέση μνήμης του Α
      daddi R6,R6,8 # +1 θέση μνήμης οπού R2 έχει την θέση μνήμης του Α
    	lw R8, 0(R2)  # R8 στοιχείο πίνακα Α
      lw R9, 0(R6)  # R9 στοιχείο πίνακα Α

      bne R8, R9, skip_addition
      #j else
      #return:
      ###################################################################
          #Την θέση του στοιχείου στην θέση i,j τον βρίσκω με την εξής πράξη R5*R1+R4 όπου R5
          #είναι η στύλη πολλαπλασιάζω με το μέγεθος τις διαστάσεις του πίνακα και προσθέτω την στυλη
          dmul R11, R5, R1 # R5*N
          dadd R11,R11,R4 #R11 = thesi stoixeiou X[i][j]
          daddi R12, R11, final #R12 = thesi mnimis pou theloyme na alla3oume
          dsub R11, R11, R7
          daddi R11, R11, -8
          daddi R11, R11, final # R11 = thesi mnimis pou theloume na paroume
          lw R11, 0(R11)
          daddi R13,R11,2
          sw R13, 0(R12)
          skip_addition:
      ########################################################################


      daddi R4, R4, 8
      bne R4, R7, Loop

  daddi R5, R5, 8#counter2
  daddi R2,R2,8
  daddi R6,R6,8
  bne R5, R7, Loop1

	;*** end
	halt

#else:
###
###
##
###
#j return
