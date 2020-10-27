  .data

str:    .asciiz "\n Please enter the number of items you are purchasing (should be less than or equal to 20): "
str1:   .asciiz "\n Sorry too many items to purchase! Please enter number of items you are purchasing"
str2:   .asciiz "\n Please enter the price of item "
str3:   .asciiz "\n Please enter the number of coupons that you want to use. "
str4:   .asciiz "\n Too many coupons! Please enter the number of coupons that you want to use."
str5:   .asciiz "\n Please enter the amount of coupon "
str6:   .asciiz "\n This coupon is not acceptable"
str7:   .asciiz "\n Your total charge is: $"
str8:   .asciiz "\n Thank you for shopping with us."
str9:   .asciiz ":\t"
priArr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
couArr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .text

main:       li $t1, 20          #input can't be greater than 20 items
            li $t2, 1           #item counter (starting at 1)
            li $t3, 0           #loop counter
            li $t5, 10          #laods 10 into t5
            la $s0, priArr          #loads address of Price Array to $s0
            la $s1, couArr          #loads address of Coupon Array to $s1
            li $v0, 4           #asks for input
            la $a0, str
            syscall
            li $v0, 5           #load integer
            syscall
            add $s3, $0, $v0        #adds input to $s3
            bgt $s3, $t1, error1        #if $s3 > $t1 --> error1
            add $a1, $s3, $0        #adds input to $a1 (limit)
            jal FillPriceArray      #jumps to subroutine to fill array with prices
            add $s2, $0, $v1        #adds price sum to s2

            #################################################################################

            la $s0, priArr          #points pointer to first location of arr1
            li $v0, 4           #asks for how many coupons
            la $a0, str3
            syscall
            li $v0, 5           #loads integer into $v0
            syscall
            bgt $v0, $s3, error2        #if input > limit, go to error
            add $t4, $v0, 0         #adds input to t4
            add $a3, $t4, $0        #adds input to a3
            jal FillCouponArray     #jumps to subroutine to fill array with coupon
            add $s5, $v1, $0        #adds coupon input to s5
            sub $t7, $s2, $s5       #subtracts price sum and coupons and puts it into t7
            li $v0, 4           #prints output
            la $a0, str7
            syscall
            li $v0, 1           #prints dollar amount
            add $a0, $t7, $0
            syscall
exit:       li $v0, 10

            syscall

FillPriceArray:li $t0, 10           #adds limit($a1) to $t0
               li $t1, 1            #adds counter to $t1
               li $t2, 0            #adds loop counter to $t2
               add $t3, $a1, $0     #adds input to t3
        read:   beq $t3, $t2, end       #if $a1 (counter) = $t2 , return to the previous address in main
            li $v0, 4           #asks for price of item
            la $a0, str2
            syscall
            
            li $v0, 1           #prints counter
            add $a0, $t1, $0
            syscall

            li $v0, 4           #prints colon and tab
            la $a0, str9
            syscall

            li $v0, 5           #loads integer into $v0
            syscall

            sw $v0, 0($s0)          #stores the integer into array1
            add $t1, $t1, 1         #adds 1 to counter

            add $t2, $t2, 1         #adds 1 to loop counter
            add $s0, $s0, 4         #increments array
            add $t4, $t4, $v0       #adds number to sum

            j read

        end:add $v1, $t4, $0

            jr $ra

FillCouponArray:    li $t0, 10          #adds 10 into t0
                    li $t1, 1           #adds counter to $t1
                    li $t2, 0           #adds loop counter to $t2
                    add $t4, $a3, $0        #adds coupon input to t4

        read1: beq $t4, $t2, end1      #beg of loop
            lw $v0, 0($s0)          #stores word from price array into $v0 // might have to move outside loop
            add $t5, $0, $v0        #stores price into $t5
            li $v0, 4           #outputs please enter amount of coupon
            la $a0, str5
            syscall

            li $v0, 1           #prints counter
            add $a0, $t1, $0

            syscall

          li $v0, 4           #prints colon and tab
            la $a0, str9

            syscall

            li $v0, 5           #loads integer into $v0
            syscall

            add $t3, $v0, $0        #adds input to t3
            bgt $t3, $t0, error3        #if input is > 10, go to error
            bgt $t3, $t5, error3        #if input is > price number
            sw $t3, 0($s1)          #stores the integer into array1
            add $t3, $t3, $v0       #adds number to sum

       increment:   add $t1, $t1, 1         #adds 1 to counter
                    add $t2, $t2, 1         #adds 1 to loop counter
                    add $s0, $s0, 4         #increments array
                    add $s1, $s1, 4         #increments array 2
                    j read1

        end1:   add $v1, $t3, $0        #adds coupon sum to v2
                jr $ra                  #returns back to addresss

error1:     li $v0, 4           #outputs too many items to purchase
            la $a0, str1

            syscall

            j main

error2:     li $v0, 4           #outputs too many coupons
            la $a0, str4
            syscall

            jr $ra

error3:     li $v0, 4           #outputs coupon is not acceptable
            la $a0, str6
            syscall

            sw $0, 0($s1)
            j increment
