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

      .text
main:
daddi R1, $zero, N #Variable's "N" base
daddi R2, $zero, arrayA #Array's "A" base
daddi R6, $zero, arrayB #Array's "B" base
daddi R10, $zero, final #"Final" Array's base...
#Address passing completed

lw    R1, 0(R1) # Load the size of dimension(N)
dsll R16, R1, 3 #bytes of one single line of each array... 
dmul R17, R16, R1 #total bytes of each array
dadd R2, R2, R16 # Skipping first line for A
dadd R6, R6, R16 # Skipping first line for Β
dadd R10, R10, R16 #skipping first line's mem positions...
#with R16 the 3 dadd commands above will work for every N given...
daddi R29, $zero, 1#assigning value 1 to R29 just for programming comfort...

dadd R5, $zero, R16 #R5 = i / γραμμές !δεν υπολογίζουμε την πρώτη γραμμή

Loop1:

  daddi R4, $zero, 8 # R4 = j / οι στύλες !δεν υπολογίζουμε την πρώτη στήλη

  Loop:


      daddi R2,R2,8 # +1 θέση μνήμης οπού R2 έχει την θέση μνήμης του Α
      daddi R6,R6,8 # +1 θέση μνήμης οπού R2 έχει την θέση μνήμης του Β
      daddi R10, R10, 8 #we don't need dmul because we can keep track of total loops...
      ld R8, 0(R2)  # R8 στοιχείο πίνακα Α
      ld R9, 0(R6)  # R9 στοιχείο πίνακα Α

      beq R8, R9, ifStatement #if A[i][j]==B[i][j]...
      j elseStatement #else...
      #return:
      ###################################################################
          ifStatement: # A[i][j]==B[i][j]
            #We will try find the position final[i-1][j-1]
            #R10 contains position of final[i][j]
            #R11 contains position of final[i-1][j-1]
            dsub R11, R10, R16 # we first build the position of final[i-1][j]
            daddi R11, R11, -8 #and we finally have final[i-1][j-1]
            ld R11, 0(R11)
            daddi R13,R11,2 #we build the value final[i-1][j-1] + 2
            sw R13, 0(R10) #and we store it in mem position of final[i][j]
            j continue
      ########################################################################
          elseStatement: # A[i][j]!=B[i][j]

            #let R24 be j - 1 :: μετάβαση στην προηγούμενη στήλη...
            #let R25 be i - 1 :: μετάβαση στην προηγούνη γραμμή...
            daddi R24, R10, -8  #R24 -> X[i][j-1]
            dsub R25, R10, R16  #R25 -> X[i-1][j]
            ##then we will create appropriate addresses for saving...
            #both will work for any N given...
            #let R21 be the value of x[i][j-1] - 1...
            #let R22 be the value of x[i-1][j] - 1...
            ld R21, 0(R24)
            ld R22, 0(R25)
            dsub R21, R21, R29 #R24 = X[i][j-1] - 1
            dsub R22, R22, R29 #R25 = X[i-1][j] - 1
            #we want two branches in order to compare 3 Elements
            slt R28, R0, R21 #if 0 < x[i][j-1] - 1
            beq R28, R29, L1 # go to address of L1
            j L3 #else go to address of L3

            L1:
            slt R28, R21, R22 #if x[i][j-1] - 1 < x[i-1][j] - 1
            beq R28, R29, L2 # go to address of L2
            j L4 # else go to address of L4

            L2: #  max = x[i-1][j] - 1
            sd R22, 0(R10)
            j continue

            L3:
            slt R28, R0, R22 # if 0 < x[i-1][j] - 1
            beq R28, R29, L2 # go to address of L2
            j L5 # else go to address of L5

            L4: #  max = x[i][j-1] - 1
            sd R21, 0(R10)
            j continue

            L5: #  max = 0
            sd R0, 0(R10)
            j continue
      ########################################################################

      continue:
      daddi R4, R4, 8 #j++
      bne R4, R16, Loop # if j < N go to loop
  dadd R5, R5, R16#counter2 i++
  daddi R2,R2,8
  daddi R6,R6,8
  #Εφόσον δεν υπολογίζουμε την πρώτη στήλη προσαρμούζουμε τισ διευθύνσεις μας ανάλογα
  daddi R10, R10, 8 #we don't need dmul because we can keep track of total loops...
  bne R5, R17, Loop1 #if it hasn't reach bottom row of array loop again
#if yes then exit program
;*** end
halt
