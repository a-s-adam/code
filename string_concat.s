		AREA strcat, CODE, READONLY
		EXPORT main 
; int main(void)
		ALIGN
main	PROC
		PUSH	{lr}
		LDR		r0,	=str1
		LDR		r1,	=str2
		LDR		r2, =str_dst
		BL		str_cat
		
		B		.
		
		MOVS	r0, #0
		POP		{pc}
	ENDP

;---------------------------------------------
; void str_cat(const char* str1, const char* str2, char* str_dst);
		ALIGN
str_cat	PROC
		; Assume all pointers are valid pointing to allocated memory
		; Assume proper string in both input arguments
		; equivalent C signature:
		; void str_cat(const char* str1, const char* str2, char* str_dst);
		
		; NOTE (CRITICAL!!!):
		; 	Before you start:
		; 	Go to startup_SAMD20.s
		; 	Find line: Heap_Size       EQU     0x00000000
		; 	Change to: Heap_Size       EQU     0x00000200
				
		; CODE BEGIN
loop1	CMP r0, #0

			BEQ loop2
			LDRB r2, [r0,#4]
			ADDS r0, r0, #1
		B   loop1
loop2   CMP r1, #0

			BEQ done
			LDRB r2, [r1,#4]
			ADDS r1, r1, #1
		B   loop2
		


done	; CODE END
	ENDP

;---------------------------------------------
		ALIGN			
		AREA str_src, DATA, READONLY
str1	DCB		"Hello",0
str2	DCB		"World!",0

		ALIGN
		AREA str_dest, DATA, READWRITE
str_dst	SPACE	13
		
	END
		
