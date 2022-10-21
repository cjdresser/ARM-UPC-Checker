                AREA question1, CODE, READONLY
                ENTRY
                      
count           EQU   6                    ;counter for Loop1
chtoint         EQU   0x480                ;because each character is loaded into register as its ascii value, sub 0x30 to convert it to its numeric value.
                                           ;subtract 3 * 6 * 0x30_16 for the 6 odd numbers which were multiplied by 3 and 
                                           ;subtract 6 * 0x30_16 for the 6 even numbers.
                                           ;3*6*0x30_16 + 6*0x30_16 = 24*0x30_16 = 0x480 
count2          EQU   10                   ;counter for SubLoop
valid           EQU   1                    ;if UPC is valid, set r1 <- 1
invalid         EQU   2                    ;if UPC is invalid, set r1 <- 2
zero            EQU   0                    ;symbolic name for 0
one             EQU   1                    ;symbolic name for 1	
                   
                
                MOV   r0, #count           ;move count = 6 into register r0 to act as loop counter
                MOV   r4, #zero            ;r4 keeps track of the total for the odd indexed characters in UPC (i.e. 1st, 3rd, 5th etc), initilixe to 0
                MOV   r5, #zero            ;r5 keeps track of the total for the even indexed characters in UPC, initialize to 0
                
                ADR   r1, UPC              ;load pointer to string into r1
                 
Loop1           LDRB  r2, [r1], #one       ;load odd indexed character of UPC into r2 and move one character forward
                ADD   r4, r4, r2           ;add odd indexed character to current total for odd indexed numbers (r4)
                
                LDRB  r2, [r1], #one       ;load even indexed character of UPC into r2 and move one character forward 
                ADD   r5, r5, r2           ;add even indexed character to current total of even indexed numbers (r5)
                SUBS  r0, r0, #one         ;decrement loop counter
                BNE   Loop1                ;loop until r0 reaches 0
                ADD   r4, r4, r4, LSL #one ;3 * r4 using add and lsl rather than mov and mul
                
                ADD   r4, r4, r5           ;add even total to odd total and store in r4
                
                SUB   r4, r4, #chtoint     ;subtract 0x30 for the ascii value of each character added to r4 (i.e. subtract 0x480 from r4)
                 
SubLoop         SUBS  r4, r4, #count2      ;loop until r1 is less than or equal to 0 (if r1 <= 0, then there was a remainder, i.e. the UPC was not valid)
                BGT   SubLoop              ;if r1 - 10 is greater than 0 loop again
                MOVEQ r1, #valid           ;move 1 to r1 if UPC is valid (i.e. no remainder)
                BEQ   exit                 ;then exit if UPC is valid
                                                        
                MOV   r1, #invalid         ;else set r1 <- 2
                                                    
                                                          
exit                                                    
Loop            B     Loop                                   
                                                          
                AREA  question1, DATA, READWRITE	
		                                                                                   	
UPC             DCB   "999999999993"       ;correct UPC
UPCI	        DCB   "013801150738"       ;incorrect UPC
UPC2            DCB   "060383755577"       ;correct UPC string
UPC3            DCB   "065633454712"       ;correct UPC string 
                                                                        
                                                    
                END