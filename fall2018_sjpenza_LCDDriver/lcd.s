;******************************************************************************
; CS 107: Computer Architecture and Organization
;
; Project: L03_LCD
; Filename: lcd.s
; Author: Salvatore Penza
; Semester: Fall 2018
; Description: This is the driver routines for the LCD Keypad Shield. The pinouts for
; the board are as follows:
;
;  | LCD Hardware | Arduino Pin | LPC 4088 Port |
;  |:------------:|:-----------:|:-------------:|
;  |     D4       |     D4      |      P0.5     |
;  |     D5       |     D5      |      P5.0     |
;  |     D6       |     D6      |      P5.1     |
;  |     D7       |     D7      |      P0.4     |
;  |     RS       |     D8      |      P5.3     |
;  |     E        |     D9      |      P5.4     |
;  |  Backlight   |    D10      |      P0.6     |
;  |  Buttons     |    A0       |      P0.23    |
;
;******************************************************************************		
BACKLIGHT_ON	EQU	0x01
BACKLIGHT_OFF	EQU	0x00
SET_LOW			EQU	0x00
SET_HIGH		EQU	0x01

GPIO_BASE	EQU 0x20098000
SET0		EQU	0x018
CLR0		EQU	0x01C
SET1		EQU	0x038
CLR1		EQU	0x03C
SET5		EQU	0x0B8
CLR5		EQU	0x0BC
	
				AREA    LCDCODE, CODE, READONLY, ALIGN=10
				IMPORT	DELAY_1_MS
				IMPORT	DELAY_2_MS
					
;******************************************************************************		
; Initializes the LCD hardware. 
;
; void LCD_INIT()
;
; D4 - D7 are I/O, RS, E, RW, and backlight are digital I/O outputs only. All
; I/O pins are outputs because the LCD Keypad Shield has the R/W* pin grounded
; so you can only write to it. Once the pins (and ports) are setup you need to
; program a sequence based on the one shown in Figure 24.
;******************************************************************************		
LCD_INIT		PROC
				EXPORT  LCD_INIT					[WEAK]
				
				PUSH	{r4-r7,lr}
				MOVS	r0, #0
				MOVW	r1, #0xC014
				MOVT	r1, #0x4002
				STR		r0, [r1]			
				MOVW	r1, #0xC280
				MOVT	r1, #0x4002
				STR		r0, [r1]			
				MOVW	r1, #0xC284
				MOVT	r1, #0x4002
				STR		r0, [r1]	
				MOVW	r1, #0xC010
				MOVT	r1, #0x4002
				STR		r0, [r1]					
				MOVW	r1, #0xC28C
				MOVT	r1, #0x4002
				STR		r0, [r1]							
				MOVW	r1, #0xC290
				MOVT	r1, #0x4002
				STR		r0, [r1]							
				MOVW	r1, #0xC018
				MOVT	r1, #0x4002
				STR		r0, [r1]							
				MOVW	r1, #0xC05C
				MOVT	r1, #0x4002
				STR		r0, [r1]	
				LDR		r1, =GPIO_BASE				
				LDR		r2, =0x800070
				STR		r2, [r1]							
				LDR		r2, =0x1B
				STR		r2, [r1, #0x0A0]
				
				BL		DELAY_2_MS			
				BL		DELAY_2_MS
				BL		DELAY_2_MS
				BL		DELAY_2_MS			
				BL		DELAY_2_MS
				BL		DELAY_2_MS
				BL		DELAY_2_MS			
				BL		DELAY_2_MS
				
				LDR		r4, =3				
				BL		WRITE_COMMAND
				
				BL		DELAY_2_MS			
				BL		DELAY_2_MS
				BL		DELAY_2_MS
		
				LDR		r4, =3				
				BL		WRITE_COMMAND
				
				BL		DELAY_1_MS			
				
				LDR		r4, =3				
				BL		WRITE_COMMAND
				BL		DELAY_1_MS
				
				LDR		r4, =2					
				BL		WRITE_COMMAND
				BL		DELAY_1_MS
				
				LDR		r4, =0x28				
				BL		WRITE_COMMAND			
				BL		DELAY_1_MS

				LDR		r4, =0x0F				
				BL		WRITE_COMMAND			
				BL		DELAY_1_MS
				
				LDR		r4, =0x1
				BL		WRITE_COMMAND			
				BL		DELAY_1_MS
				
				LDR		r4, =0x6				
				BL		WRITE_COMMAND
				 
				POP		{r4-r7,pc}

				ENDP


;******************************************************************************		
; Writes a string to the first or second line of the LCD Keypad Shield.
;
; void WRITE_CSTRING(uchar_32 line, char *string)
;
; r4 contains which line with 0 being the top line and 1 the bottom. r5
; contains the address of the first character to be output. When writing a
; character be sure to wait 2 ms between characters.
;******************************************************************************		
WRITE_CSTRING	PROC
				EXPORT  WRITE_CSTRING					[WEAK]

				PUSH	{r4-r7,lr}
				
				CMP		r4, #0					
				LDREQ	r4, =2					
				BLEQ	WRITE_COMMAND
				BEQ		write_data
				
				CMP		r4, #1					
				BNE		end1					
				
				LDREQ	r4, =0xC0				
				BLEQ	WRITE_COMMAND			
				BEQ		write_data
				
write_data		LDRB	r4, [r5]				
				
loop1			CBZ 	r4, end1				
				BL		DELAY_1_MS
				BL		DELAY_1_MS
				BL		WRITE_DATA				
				LDRB	r4, [r5, #1]!			
				B		loop1

end1			POP		{r4-r7,pc}
							
				ENDP


;******************************************************************************		
; Writes a command byte to the LCD Keypad Shield
;
; void WRITE_COMMAND(uint_32 value)
;
; r4 contains the value to write. This routine simply sets the RS signal and
; calls WRITE_BYTE.
;******************************************************************************		
WRITE_COMMAND	PROC
				EXPORT  WRITE_COMMAND					[WEAK]

				PUSH	{r4-r7,lr}
				MOV		r5, r4				
				LDR		r4, =SET_LOW			
				BL		SET_RS		
				BL		DELAY_2_MS
				MOV		r4, r5					
				BL		WRITE_BYTE		
				POP		{r4-r7,pc}
					
				ENDP

;******************************************************************************		
; Writes a data byte to the LCD Keypad Shield
;
; void WRITE_COMMAND(uint_32 value)
;
; r4 contains the value to write. This routine simply sets the RS signal and
; calls WRITE_BYTE.
;******************************************************************************		
WRITE_DATA		PROC
				EXPORT  WRITE_DATA					[WEAK]
				
				PUSH	{r4-r7,lr}
				MOV		r5, r4					
				LDR		r4, =SET_HIGH			
				BL		SET_RS					
				BL		DELAY_2_MS
				MOV		r4, r5					
				BL		WRITE_BYTE				
				POP		{r4-r7,pc}
				
				ENDP

;******************************************************************************		
; Writes a byte to the LCD Keypad Shield
;
; void WRITE_BYTE(uint_32 value)
;
; r4 contains the value to write. We should set the RS signal before calling
; this routine. Setting RS to LOW gives us a command and setting RS to HIGH
; gives us a data command. Since our LCD Keypad Shield is using a 4-bit
; interface we need to send out the MS nybble first followed by the LS nybble.
;******************************************************************************		
WRITE_BYTE		PROC
				EXPORT  WRITE_BYTE					[WEAK]
				
				PUSH	{r4-r7,lr}
				MOV		r5, r4					
				LSR		r4, r5, #4				
				BL		WRITE_LS_NYBBLE			
				BL		DELAY_2_MS
				AND		r4, r5, #0xF			
				BL		WRITE_LS_NYBBLE			
				POP		{r4-r7,pc}
				
				ENDP

;******************************************************************************		
; Writes the LS nybble to the LCD Keypad Shield.
;
; void WRITE_LS_NYBBLE(uint_32 value)
;
; r4 contains the value to write. It is assumed that the RS line has already
; been set to the proper value. Be sure to set E to HIGH, output the data, and
; set E to LOW to write the data to the LCD Keypad Shield.
;******************************************************************************		
WRITE_LS_NYBBLE	PROC
				EXPORT  WRITE_LS_NYBBLE					[WEAK]
				
				PUSH	{r4-r9,lr}
				MOV		r5, r4					
				MOV		r6, #0					
				MOV		r7, #0
				MOV		r8, #0
				MOV		r9, #0
				LDR		r4, =SET_HIGH			
				BL		SET_E
				LDR		r1, =GPIO_BASE			
				
				LSRS	r5, r5, #1				
				ADDCS	r6, r6, #0x20			
				ADDCC	r7, r7, #0x20			
				
				LSRS	r5, r5, #1				
				ADDCS	r8, r8, #1				
				ADDCC	r9, r9, #1				
				
				LSRS	r5, r5, #1				
				ADDCS	r8, r8, #2				
				ADDCC	r9, r9, #2				
				STR		r8, [r1, #SET5]			
				STR		r9, [r1, #CLR5]			
				
				LSRS	r5, r5, #1				
				ADDCS	r6, r6, #0x10			
				ADDCC	r7, r7, #0x10			
				STR		r6, [r1, #SET0]			
				STR		r7, [r1, #CLR0]		
				
				LDR		r4, =SET_LOW		
				BL		SET_E					
				POP		{r4-r9, pc}
				
				ENDP

;******************************************************************************		
; Sets the RS data line to the value passed.
;
; void SET_RS(uint_32 status)
;
; r4 contains the value to set RS. RS is bit P5.3 which is already set to output.
;******************************************************************************		
SET_RS			PROC
				EXPORT  SET_RS					[WEAK]
				
				PUSH	{lr}
				LDR		r1, =GPIO_BASE
				TST		r4, #1					
				LDR		r2, =0x8						
				BL			DELAY_1_MS
				STRNE	r2, [r1, #SET5]			
				STREQ	r2, [r1, #CLR5]						
				BL			DELAY_1_MS
				POP		{pc}

				ENDP

;******************************************************************************		
; Sets the E data line to the value passed.
;
; void SET_E(uint_32 status)
;
; r4 contains the value to set E. E is bit P5.4 which is already set to output.
;******************************************************************************		
SET_E			PROC
				EXPORT  SET_E					[WEAK]
				
				PUSH	{lr}
				LDR		r1, =GPIO_BASE
				TST		r4, #1						
				LDR		r2, =0x10
				BL			DELAY_1_MS
				STRNE	r2, [r1, #SET5]			
				STREQ	r2, [r1, #CLR5]			
				BL			DELAY_1_MS
				POP		{pc}
				
				ENDP

;******************************************************************************		
; Turns on or off the LCD backlight. The parameter status is passed on the 
; stack.
;
; void LCD_BACKLIGHT(int status)
;
; status - 1 turn on backlight, 0 - turn off backlight
;******************************************************************************		
LCD_BACKLIGHT	PROC
				EXPORT  LCD_BACKLIGHT					[WEAK]
				
				PUSH		{lr}
				
				LDR			r0, [sp, #4]			
				LSRS		r0, r0, #1				
				LDR			r1, =GPIO_BASE			
				LDR			r2, =0x40
				BL			DELAY_1_MS
				STRCS		r2, [r1, #SET0]			
				STRCC		r2, [r1, #CLR0]			
				BL			DELAY_1_MS
				POP			{pc}
				
				ENDP

				END