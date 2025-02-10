.data
employees:
    .word 1           #id
    .asciiz "rachid"   #nom
    .word 5000        #salaire

    .word 2           
    .asciiz "Fatima"  
    .word 7000        

    .word 3           
    .asciiz "Khalid"  
    .word 4000        

num_employees: .word 3  

menu: .asciiz "\n1. Afficher les employés\n2. Rechercher par ID\n3. Salaire Min/Max\n4. Afficher le salaire moyen\n5. Nombre d'employés avec salaire supérieur au moyen\n6. Masse salariale de l'entreprise\n7. Quitter\nChoix: "
invalid_choice: .asciiz "\nChoix invalide. Réessayez.\n"
enter_id: .asciiz "\nEntrez l'ID de l'employé : "
not_found: .asciiz "\nEmployé non trouvé.\n"
min_max_msg: .asciiz "\nSalaire Min: "
max_msg: .asciiz " DH, Salaire Max: "
average_msg: .asciiz "\nSalaire Moyen: "
num_above_avg_msg: .asciiz "\nNombre d'employés avec un salaire supérieur au salaire moyen: "
total_salary_msg: .asciiz "\nMasse salariale de l'entreprise: "

.text
.globl main

main:
    la $a0, menu           
    li $v0, 4
    syscall

    li $v0, 5              
    syscall
    move $t0, $v0          

    beq $t0, 1, display_employees
    beq $t0, 2, search_employee
    beq $t0, 3, calculate_min_max
    beq $t0, 4, display_average
    beq $t0, 5, count_above_average
    beq $t0, 6, display_total_salary
    beq $t0, 7, exit_program
    la $a0, invalid_choice 
    li $v0, 4
    syscall
    j main                 

display_employees:
    li $t1, 0              
    lw $t2, num_employees  
    la $t3, employees      
display_loop:
    bge $t1, $t2, main     

    lw $a0, 0($t3)         
    li $v0, 1
    syscall

    la $a0, 4($t3)         
    li $v0, 4
    syscall

    lw $a0, 12($t3)        
    li $v0, 1
    syscall

    addi $t3, $t3, 16      
    addi $t1, $t1, 1       
    j display_loop

search_employee:
    la $a0, enter_id       
    li $v0, 4
    syscall

    li $v0, 5              
    syscall
    move $t4, $v0          

    li $t1, 0
    lw $t2, num_employees  
    la $t3, employees
search_loop:
    bge $t1, $t2, search_not_found 

    lw $t5, 0($t3)         
    beq $t4, $t5, search_found

    addi $t3, $t3, 16      
    addi $t1, $t1, 1
    j search_loop

search_found:
    la $a0, 4($t3)         
    li $v0, 4
    syscall

    lw $a0, 12($t3)        
    li $v0, 1
    syscall
    j main

search_not_found:
    la $a0, not_found      
    li $v0, 4
    syscall
    j main

calculate_min_max:
    li $t1, 0              
    lw $t2, num_employees
    la $t3, employees

    lw $t4, 12($t3)        
    move $t5, $t4          
    move $t6, $t4          

calc_loop:
    bge $t1, $t2, calc_done

    lw $t4, 12($t3)        
    blt $t4, $t5, update_min
    bgt $t4, $t6, update_max
    j next_calc

update_min:
    move $t5, $t4
    j next_calc

update_max:
    move $t6, $t4

next_calc:
    addi $t1, $t1, 1
    addi $t3, $t3, 16
    j calc_loop

calc_done:
    la $a0, min_max_msg    
    li $v0, 4
    syscall

    move $a0, $t5          
    li $v0, 1
    syscall

    la $a0, max_msg        
    li $v0, 4
    syscall

    move $a0, $t6          
    li $v0, 1
    syscall

    j main

display_average:
    li $t1, 0              
    li $t7, 0              
    lw $t2, num_employees
    la $t3, employees

average_loop:
    bge $t1, $t2, average_done

    lw $t4, 12($t3)        
    add $t7, $t7, $t4      
    addi $t1, $t1, 1
    addi $t3, $t3, 16
    j average_loop

average_done:
    div $t7, $t2           
    mflo $t8               

    la $a0, average_msg    
    li $v0, 4
    syscall

    move $a0, $t8          
    li $v0, 1
    syscall

    j main

count_above_average:
    li $t1, 0              
    li $t9, 0              
    la $t3, employees

above_avg_loop:
    bge $t1, $t2, above_avg_done

    lw $t4, 12($t3)        
    bgt $t4, $t8, above_avg_increment
    j next_avg

above_avg_increment:
    addi $t9, $t9, 1       

next_avg:
    addi $t1, $t1, 1
    addi $t3, $t3, 16
    j above_avg_loop

above_avg_done:
    la $a0, num_above_avg_msg
    li $v0, 4
    syscall

    move $a0, $t9          
    li $v0, 1
    syscall

    j main

display_total_salary:
    li $t1, 0              
    li $t7, 0              
    lw $t2, num_employees
    la $t3, employees

total_salary_loop:
    bge $t1, $t2, total_salary_done

    lw $t4, 12($t3)        
    add $t7, $t7, $t4      
    addi $t1, $t1, 1
    addi $t3, $t3, 16
    j total_salary_loop

total_salary_done:
    la $a0, total_salary_msg
    li $v0, 4
    syscall

    move $a0, $t7          
    li $v0, 1
    syscall

    j main

exit_program:
    li $v0, 10             
    syscall
