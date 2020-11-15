			#include<p18F4550.inc>

innerloop	set	0x00
outerloop	set	0x01
			
			org 0x00
			goto start
			org 0x08
			retfie
			org 0x18
			retfie

;***************************************
;Subroutine for 7 segment display
;***************************************

showA		MOVLW	B'01110111'
			MOVFF	WREG, PORTD
			RETURN

offLED		CLRF	PORTD, A
			RETURN

;***************************************
;Subroutine for 83mili sec delay
;***************************************

dup_nop		macro num
			variable i
i = 0
			while i < num
			nop
i += 1
			endw
			endm

;1/20M = 50ns
;4*50 = 200ns
;83ms/200ns
;415,000 times
;100*50*83 = 415,000 times

DELAY		MOVLW	D'83'			;83m sec delay subroutine for
			MOVWF	outerloop, A	;20MHz crystal frequency
AGAIN1		MOVLW	D'50'
			MOVWF	innerloop, A
AGAIN2		dup_nop	D'97'
			DECFSZ	innerloop, F, A
			BRA		AGAIN2
			DECFSZ	outerloop, F, A
			BRA		AGAIN1
			NOP
			RETURN

;***************************************
;My Main Program
;***************************************

start		CLRF	TRISD, A
			CLRF	PORTD, A
LOOP		CALL	showA
			CALL	DELAY
			CALL	offLED
			CALL	DELAY
			BRA		LOOP

			END