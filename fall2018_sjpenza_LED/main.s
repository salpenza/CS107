;******************************************************************************
; CS 107: Computer Architecture and Organization
;
; Project: first
; Filename: main.s
; Author: Sal Penza
; Semester: Fall 2049
; Description: This program lights an LED.
;
;******************************************************************************		
LED_LOW		EQU	0x3C
LED_HIGH	EQU	0x38
RED			EQU 0x800
GREEN		EQU	0x20	
BLUE		EQU 0x80		
YELLOW		EQU	0x820
PURPLE		EQU	0x880
	
				AREA    SBCCCODE, CODE, READONLY, ALIGN=10
					
start			PROC
				EXPORT  start					[WEAK]
					
				; IOCON_P1_13 R/W 0x4002C0B4
				; FUNC: 000 - Digital I/O pin
				; MODE: 00 - No pullup/pulldown
				; Load value into R0
				MOVS	r0, #0
				MOV		r4,#0x4
				
				MOVW	r1, #0xC0B4
				MOVT	r1, #0x4002

				STR		r0, [r1]
				
				MOVW	r1, #0xC0AC
				MOVT	r1, #0x4002
				
				STR		r0, [r1]
				
				MOVW	r1, #0xC09C
				MOVT	r1, #0x4002
				
				STR		r4, [r1]
				
				MOVW	r1, #0xC094
				MOVT	r1, #0x4002
				
				STR		r0, [r1]
				; Set base address for GPIO 0x20098000
				; MOVW	r1, #0x8000
				; MOVT	r1, #0x2009
				; Same as above but using the psedo-instruction.
				LDR		r1,=0x20098000
				
				; Set bit P1.13 to be an output
				MOVS	r0, #0x2000
				STR		r0, [r1, #0x20]

				; Set the bit to low (0x3C) or hi (0x38)
				STR		r0, [r1, #LED_LOW]

				; Loop forever
				B       .
				ENDP
					
				END
