;******************************************************************************
; CS 107: Computer Architecture and Organization
;
; Project: L03_LCD
; Filename: delay.s
; Author: Salvatore Penza
; Semester: Fall 2018
; Description: Various delay routines.
;
;******************************************************************************		
	
				AREA    DELAYCODE, CODE, READONLY, ALIGN=10

;******************************************************************************		
; Delays for one millisecond.
;
; void DELAY_1_MS()
;
; This is a simple loop which will delay for approximately one millisecond. A
; loop count of 3000 will work.
;******************************************************************************		
DELAY_1_MS		PROC
				EXPORT  DELAY_1_MS					[WEAK]
				
				PUSH	{r4, lr}
				LDR		r4, =3000
loop1			CBZ		r4, end1
				SUB 	r4, r4, #1
				B 		loop1
end1
				POP		{r4, pc}				
				ENDP

;******************************************************************************		
; Delays for about two milliseconds.
;
; void DELAY_2_MS()
;
; This 2 ms delay is longer than the longest command will take to the LCD
; Keypad display.
;******************************************************************************		
DELAY_2_MS		PROC
				EXPORT  DELAY_2_MS					[WEAK]
				
				PUSH 	{r4, lr}
				LDR		r4, =7000
loop2			CBZ		r4, end2
				SUB		r4, r4, #1
				B 		loop2
end2
				POP		{r4, pc}
				ENDP

				END
