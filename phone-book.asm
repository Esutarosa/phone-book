.data
Prompt_Message   : .asciiz "\nPlease determine operation, entry (E), inquiry (I) or quit (Q):\n"
Final_Message    : .asciiz "\nThank you!\n"
errorMessage1    : .asciiz "\nThe character you have entered does not correspond to any operation.\n"
errorMessage2    : .asciiz "\nThere is no such entry in the phonebook.\n"
errorMessage3    : .asciiz "\nThere have already been 10 entries!\n"
I_Message        : .asciiz "\nEnter the number of the entry you wish to retrieve:\n"
nameMessage      : .asciiz "\nPlease enter first name:\n"
surnameMessage   : .asciiz "Please enter last name:\n"
phoneMessage     : .asciiz "Please enter the phone:\n"
PEMessage        : .asciiz "\nThe number is:\n"
dotAndSpace      : .asciiz ". "
NEntryMessage    : .asciiz "\nThank you, the new entry is:\n"

.align 2
usersName        : .space 20    
usersSurname     : .space 20
usersPhone       : .space 20
FString          : .space 62
list             : .space 620 

.text
main:
    addiu $sp, $sp, -8            # Makes space by moving stack pointer
    la $s3, list($zero)           # Loads address of the start of the list into $s3
    sw $s3, 0($sp)                # Pushes $s3 (saves $s3 at offset 4)
    sw $ra, 4($sp)                # Main is a caller so we store $ra
    addi $s1, $0, 0               # Initialize s1, the counter for entries
    addi $s2, $0, 0               # Initialize s2 (list's index)

while:
    jal Prompt_User               # Call Prompt_User to print the prompt and return user's character
    addi $t0, $v0, 0              # Set $t0 to the return value of Prompt_User
    
    # Check for 'Q' or 'q' to quit
    ori $a3, $0, 81               # 81 -> 'Q' in ASCII code
    beq $a3, $t0, exit            # If 'Q', terminate program
    ori $a3, $0, 113              # 113 -> 'q' in ASCII code
    beq $a3, $t0, exit            # If 'q', terminate program
    
    # Check for 'I' to inquire
    ori $a3, $0, 73               # 73 -> 'I' in ASCII code
    beq $a3, $t0, Print_Entry     # If 'I', jump to Print_Entry
    
    # Check for 'E' to enter new entry
    ori $a3, $0, 69               # 69 -> 'E' in ASCII code
    beq $a3, $t0, Get_Entry       # If 'E', jump to Get_Entry

    # Print error message for invalid input
    li $v0, 4                    
    la $a0, errorMessage1
    syscall
    
    j while

exit:
    lw $ra, 4($sp)                # Pop $ra
    lw $s3, 0($sp)                # Pop $s3
    addiu $sp, $sp, 8             # Reset stack pointer
    jal Terminate_Program         # Terminate program
    jr $ra

Prompt_User:
    li $v0, 4                     # Print Prompt_Message
    la $a0, Prompt_Message
    syscall
    
    li $v0, 12                    # Read user's character
    syscall
    jr $ra

Print_Entry:
    li $v0, 4                     # Print I_Message
    la $a0, I_Message
    syscall

    li $v0, 5                     # Read user's integer
    syscall
    
    addi $t6, $v0, 0              # Set $t6 to user's input
    addi $t4, $zero, 1            # Set $t4 to 1 to check if input is less than 1
    slt $a3, $t6, $t4             # Compare if $t6 < $t4
    bne $a3, $0, EInput           # If true, jump to EInput
    slt $a3, $s1, $t6             # Compare if $t6 > number of entries ($s1)
    bne $a3, $0, EInput           # If true, jump to EInput
    
    # Define boundaries of the wanted entry
    addi $t4, $zero, 62           # Set $t4 to 62 (max space of one entry)
    mul $t5, $t6, $t4             # Max boundary: $t5 = $t6 * 62 - 1
    addi $t5, $t5, -1
    addi $t6, $t6, -1             # Min boundary: $t3 = ($t6 - 1) * 62
    mul $t3, $t6, $t4
    addi $t1, $zero, 0            # Initialize index of FString
    
while6:
    lb $t2, list($t3)             # Load each byte of the list to $t2
    sb $t2, FString($t1)          # Store $t2 to FString
    beq $t3, $t5, endOfTheEntry   # Exit loop when index reaches max boundary
    addi $t1, $t1, 1              # Increase index of FString
    addi $t3, $t3, 1              # Increase index of list
    j while6

endOfTheEntry:
    li $v0, 4                     # Print PEMessage
    la $a0, PEMessage
    syscall
    
    li $v0, 1                     # Print user's input integer
    addi $a0, $t6, 1
    syscall
    
    li $v0, 4                     # Print dot and space
    la $a0, dotAndSpace
    syscall
    
    li $v0, 4                     # Print the entry
    la $a0, FString
    syscall

delete1:
    sb $zero, FString($t1)        # Delete FString
    beq $t1, $zero, while         # If deleted, jump back to while
    addi $t1, $t1, -1
    j delete1

EInput:
    li $v0, 4                     # Print errorMessage2
    la $a0, errorMessage2
    syscall
    j while                       # Jump back to while

Get_Entry:
    slti $a3, $s1, 10
    beq $a3, $0, FullEntries      # If more than 10 entries, print error and jump back to while
    addi $s1, $s1, 1              # Increase entry counter
    
    jal Get_Name                  # Get user's first name
    jal Get_Surname               # Get user's last name
    jal Get_Phone                 # Get user's phone
    jal combine                   # Combine name, surname, and phone into FString
    
    j while

FullEntries:
    li $v0, 4                     # Print errorMessage3
    la $a0, errorMessage3
    syscall
    j while                       # Jump back to while

delete:
    while5:
        sb $zero, FString($a1)    # Delete FString
        beq $a1, $zero, continue
        addi $a1, $a1, -1
        j while5
continue:
    jr $ra

combine:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)                # Store $ra
    addi $t5, $0, 32              # Space in ASCII
    addi $a1, $0, 0               # Initialize FString's index
    addi $t4, $0, 0               # Initialize index for usersName, usersSurname, usersPhone
    addi $t3, $0, 10              # Enter in ASCII
    addi $t6, $zero, 19           # Max length
    
while1:
    lb $t2, usersName($t4)        # Load byte from usersName
    beq $t4, $t6, endName
    beq $t2, $t3, endName         # If enter, stop
    sb $t2, FString($a1)          # Store to FString
    addi $a1, $a1, 1              # Increase FString's index
    addi $t4, $t4, 1              # Increase usersName index
    j while1

endName:
    sb $t5, FString($a1)          # Store space to FString
    addi $a1, $a1, 1
    
while2:
    lb $t2, usersSurname($t4)     # Load byte from usersSurname
    beq $t4, $t6, endSurname
    beq $t2, $t3, endSurname      # If enter, stop
    sb $t2, FString($a1)          # Store to FString
    addi $a1, $a1, 1              # Increase FString's index
    addi $t4, $t4, 1              # Increase usersSurname index
    j while2

endSurname:
    sb $t5, FString($a1)          # Store space to FString
    addi $a1, $a1, 1
    
while3:
    lb $t2, usersPhone($t4)       # Load byte from usersPhone
    beq $t4, $t6, endPhone
    beq $t2, $t3, endPhone        # If enter, stop
    sb $t2, FString($a1)          # Store to FString
    addi $a1, $a1, 1              # Increase FString's index
    addi $t4, $t4, 1              # Increase usersPhone index
    j while3

endPhone:
    sb $t3, FString($a1)          # Store enter to FString
    addi $a1, $a1, 1
    
while4:
    lb $t2, FString($t4)          # Load byte from FString
    sb $t2, list($s2)             # Store to list
    addi $s2, $s2, 1              # Increase list's index
    addi $t4, $t4, 1              # Increase FString's index
    beq $t2, $t3, End             # If enter, stop
    j while4

End:
    lw $ra, 0($sp)                # Restore $ra
    addiu $sp, $sp, 4
    jr $ra

Get_Name:
    li $v0, 4                     # Print nameMessage
    la $a0, nameMessage
    syscall

    li $v0, 8                     # Read string for first name
    la $a0, usersName
    li $a1, 20
    syscall
    jr $ra

Get_Surname:
    li $v0, 4                     # Print surnameMessage
    la $a0, surnameMessage
    syscall

    li $v0, 8                     # Read string for last name
    la $a0, usersSurname
    li $a1, 20
    syscall
    jr $ra

Get_Phone:
    li $v0, 4                     # Print phoneMessage
    la $a0, phoneMessage
    syscall

    li $v0, 8                     # Read string for phone
    la $a0, usersPhone
    li $a1, 20
    syscall

    li $v0, 4                     # Print NEntryMessage
    la $a0, NEntryMessage
    syscall

    li $v0, 4                     # Print the new entry
    la $a0, FString
    syscall
    jr $ra

Terminate_Program:
    li $v0, 4                     # Print Final_Message
    la $a0, Final_Message
    syscall

    li $v0, 10                    # Exit program
    syscall