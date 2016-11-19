;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   �� ��� 16 2016
; Processor: AT89C51RD2
; Compiler:  ASEM-51 (Proteus)
;====================================================================

$NOMOD51
$INCLUDE (8051.MCU)

;====================================================================
; DEFINITIONS
;====================================================================
	
;====================================================================
; VARIABLES
;====================================================================
		YELLOW bit p2.0
		RED    bit p2.1
		BLUE   bit p2.2
        
		D07    equ p1
		D8     bit p3.0
		D9     bit p3.1
		
		OE	   bit p3.2
		HOLD   bit p3.3
		CLK    bit p3.4
		
		WAIT   equ 20h
		CONVERTION_COMPLETE bit 21h.0
		
		MIN_0    equ 22h
		MIN_1    equ 23h
		MAX_0    equ 24h
		MAX_1    equ 25h
		CARRY    equ 28h 
		TMP_0    equ 29h
		TMP_1    equ 2Ah
		IS_LESS  bit 21h.1
;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      org   0000h
	  jmp   Start
	  
	  org   000bh
;====================================================================
; CODE SEGMENT
;====================================================================

      org   0100h
Start:
          mov  a, #0
          subb a, #0
          setb OE
	  setb HOLD
          setb CLK
	  mov  MIN_0, #203
	  mov  MIN_1, #0
          mov  MAX_0, #202
	  mov  MAX_1, #3
      ; Write your code here
Loop:
	  call StartADC
	  call WaitADC
	  call FinishADC
	  call Handle2
      jmp Loop
StartADC:
	  clr HOLD
          clr CLK
	  setb  CLK
	  ret
FinishADC:
          setb HOLD
          clr CLK
	  setb  CLK
	  ret
WaitADC:
          mov  WAIT, #90
          djnz WAIT, $
	  ret

Handle2:
	  mov  TMP_0, MIN_0
	  mov  TMP_1, MIN_1
	  call CheckLess
          jb   IS_LESS, Cold
	  mov  TMP_0, MAX_0
	  mov  TMP_1, MAX_1 
	  call CheckLess
	  jb   IS_LESS, Norm
	  Hot:
		  clr RED
		  setb YELLOW
		  setb BLUE
		  ret
	  Norm:
		  setb RED
		  clr YELLOW
		  setb BLUE
		  ret
	  Cold:
		  setb RED
		  setb YELLOW
		  clr BLUE
		  ret
CheckLess:
	  clr IS_LESS
	  mov  a, TMP_1
	  mov  a, P3
	  anl  a, #3
          mov  psw, #0
	  subb a, TMP_1
	  jz   Check0
	  jc  Less  
	  ret
	  Check0:
		 mov  a,   TMP_0
		 mov  a,   P1
		 subb a,   TMP_0
	     jc  Less 
		 ret
	  Less:
		 setb IS_LESS
		 ret
	  
;====================================================================
      END