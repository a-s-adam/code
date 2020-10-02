		AREA fib_recursive, CODE, READONLY
		EXPORT main 
; int main(void)
		ALIGN
main	PROC
		
		MOVS 	r0, #0
		BL		fib ; expected 0
		MOVS 	r0, #1
		BL		fib ; expected 1
		MOVS 	r0, #2
		BL		fib ; expected 1
		MOVS 	r0, #5
		BL		fib ; expected 5
		MOVS 	r0, #8
		BL		fib ; expected 21
		MOVS 	r0, #10
		BL		fib ; expected 55
		MOVS 	r0, #29
		BL		fib ; expected 514229
		
		B		.
		
		MOVS	r0, #0
		POP		{pc}
	ENDP

;---------------------------------------------
; uint32_t fib(uint32_t idx);
		ALIGN
fib		PROC
		; Implement recursive version of function calculating Fibonacci sequence
		; Function gets the index of a fibonnacci number and returns the calculated value
		; equivalent C signature:
		; uint32_t fib(uint32_t idx);
		; base condition:
		;	fib(0) = 0
		;	fib(1) = 1
		
		; NOTE (CRITICAL!!!):
		; 	Before you start:
		; 	Go to startup_SAMD20.s
		; 	Find line: Heap_Size       EQU     0x00000000
		; 	Change to: Heap_Size       EQU     0x00000200
		PUSH{LR}
		;r0 is decrementing
		MOVS r4, #1; f(1)
		MOVS r1, #0; f(0)
loop 	CMP r0, #0
		BEQ done
		MOVS r3, r1
		ADDS r1, r1, r4
		MOVS r4, r3
		SUBS r0, #1
		B loop
done 	MOVS r0, r1
		POP {PC}
		; CODE END
	ENDP
		
	END
		
