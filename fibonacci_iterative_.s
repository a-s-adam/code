		AREA fib_iterative, CODE, READONLY
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
		; Implement iterative version of function calculating Fibonacci sequence
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
		 PUSH{r4,r5,r6,LR}
		 MOVS r4, r0; n value
		 MOVS r5, r0
		 CMP r0, #1
		 BLE return
		 SUBS r0, r4, #1 
		 SUBS r5, r4, #2
		 BL fib ;fib(n-1)
		 MOVS r6, r0 ;store f(n-1)
		 MOVS r0, r5 ;fib (n-2)
		 BL fib
		 ADDS r0, r6, r0 ; fib(n-1) + fib(n-2)
		 POP {r4,r5,r6,PC}
return   MOVS r0,r4
		 POP {r4,r5,r6,PC} 
		
		
		; CODE BEGIN

		; CODE END
	ENDP
		
	END
		
