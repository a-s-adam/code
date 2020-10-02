		AREA gcd_COMP, CODE, READONLY
		EXPORT main 
;int main(void)
		ALIGN
main PROC
		; Given the initial data in in_arr. 
		; Implement function which will calculate GCD for every permutaion
		; of arr_in with itself
		; 1. Allocate sufficient ammount of space in readwrite area
		; 2. Create utility procedure: 
		;    uint32_t gcd(const int32_t a, const int32_t b)
		;	 NOTE: Watch out for the sign
		; 3. Create procedure 
		;	 void compute_gcd(const *int32_t src, uint32_t src_sz, uint32_t *out, uint32_t out_sz)
		;	Set up the value and pointer arguments and call it from main.
		;   Prove the correctness of the result
		; 4. Use provided mod procedure to calculate modulus of two positive integers
		;	uint32_t mod(uint32_t a, uint32_t b); // y = a%b
		;	NOTE: Pay attention to subroutine preserved registers!!!!
				
		; NOTE (CRITICAL!!!):
		; 	Before you start:
		; 	Go to startup_SAMD20.s
		; 	Find line: Heap_Size       EQU     0x00000000
		; 	Change to: Heap_Size       EQU     0x00000200
				
		PUSH	{lr}
		; CODE BEGIN
		LDR r3, =in_arr
		LDR r1, =in_sz
		LDR r2, =out_arr
		BL compute_gcd
		; CODE END
		
		B		.
		
		MOVS	r0, #0
		POP		{pc}
	ENDP

;------------------------------------------------
;void compute_gcd(const *int32_t src, uint32_t src_sz, uint32_t *out, uint32_t out_sz)
; IMPLEMENT ME !!!!!!
	ALIGN
compute_gcd PROC
	PUSH {LR}
	LDR r5, [r1];local var for in_sz
	SUBS r3,#4
	ADDS r5,#1
	SUBS r6,#1
loop1 CMP r5, #0
	  BEQ done
	  MOVS r6,#1
	  ADDS r3,#4
	  SUBS r5,#1;size
loop2	    CMP r6, r5;increment to size
			BEQ loop1
			LDR r0, [r3];number 'a' in gcd
			LSLS r7, r6, #2
			LDR r1, [r3,r7];counts up the array in GCD
		    PUSH {r2}
			BL gcd
			MOVS r0, r2
			POP {r2}
			STR r0,[r2];out_arr storing!
			ADDS r2,#4;offset creater
			ADDS r6, #1
			B loop2
	
	
done POP {PC}
	 ENDP

;------------------------------------------------
;uint32_t gcd(const int32_t a, const int32_t b)
; IMPLEMENT ME !!!!!!
	ALIGN
gcd 	  PROC
			PUSH {LR}
			CMP r0, #0
			BGT skipnegate
			MVNS r0, r0; make r0 positive via 2's complement.
skipnegate  CMP r1, #0
			BGT skipnegate2
			MVNS r1, r1;make r1 positive via 2's complement.
skipnegate2 CMP r0, r1
			BGT gcd_loop ;if a < b swap them!
			MOVS r2, r0
			MOVS r0, r1
			MOVS r1, r2
gcd_loop    CMP r0, #0
			BEQ gcd_done
			PUSH {r0, r1}
			BL mod ; r0 % r1
			CMP r0, #0
			BEQ gcd_done
			MOVS r2,r0 ;storing remainder into r2
			POP{r0,r1} ; popping a & b 
			MOVS r0,r1 ; move b to a
			MOVS r1, r2
			B gcd_loop
			
gcd_done    POP {r0,r1}
			MOVS r0, r2
			POP{PC}
		ENDP
;------------------------------------------------
;uint32_t mod(uint32_t a, uint32_t b)
		ALIGN
mod	PROC
		; both r0 and r1 must be positive
		; r0 >= r1
mod_loop
		CMP		r0, #0
		BEQ		mod_exit
		CMP		r0,	r1
		BLT		mod_exit
		SUBS	r0, r0, r1
		B		mod_loop

;Exit conditions:
; r0 = 0 r0 divisible by r1 returning value of 0 in r0
; r0 < r1 r0 not divisible by r1 returning remainder in r0
mod_exit
		BX		lr
	ENDP

;------------------------------------------------
		ALIGN
		AREA str_src, DATA, READONLY
in_arr	DCD		1,12,20,-16,36,4096,78,-68,-2789
in_sz	DCD		9
;------------------------------------------------
		ALIGN
		AREA result, DATA, READWRITE
out_arr 	SPACE 144 ; 36 different possible gcd's, so 4 bytes * 36 = 144
;Allocate enough space to store the result

	
	END
		
