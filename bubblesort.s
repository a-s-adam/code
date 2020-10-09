		AREA bubblesort_seg, CODE, READONLY
		EXPORT main 
;int main(void)
		ALIGN
main PROC
		; Given the data in arr. 
		; Implement function sorting ther array using bubblesort algorithm
		; The resulting array must be sorted in ascending order
		
		; Create procedure
		; void bubblesort( int32_t* min, int32_t* mid, int_32* max, int32_t* arr, int32_t arr_sz)
		; The function receives three pointers and a value
		
		; The fourth argument is the pointer to an array,
		; The fifth is the array size passed by value
		
		; Arguments 1-3 are pointers so memory space where bubble sort will additionally store 
		; minumum elemen, maximum element and element in the middle fo the array
		; if the array length is even then store the n/2 element if iodd store the central element
		
		; For the array assume correct pointers and non zero length array
		
		; 1. Allocate additional space for min, mid and max,
		; 2. Implement the function
		; 3. Call the function according to the EABI guidance
				
		; NOTE (CRITICAL!!!):
		; 	Before you start:
		; 	Go to startup_SAMD20.s
		; 	Find line: Heap_Size       EQU     0x00000000
		; 	Change to: Heap_Size       EQU     0x00000200
				
		; CODE BEGIN
		PUSH	{lr}

		;r0, r1, r2 will be min mid max. r4 will be set to arr_sz inside bubblesort.
		BL bubblesort
		
		; CODE END
		B		.
		
		MOVS	r0, #0
		POP		{pc}
	ENDP

;------------------------------------------------
;void bubblesort( int32_t* min, int32_t* mid, int_32* max, int32_t* arr, int32_t arr_sz)
; IMPLEMENT ME !!!!!!
bubblesort PROC
	LDR r4, =arr
	LDR r5, =arr_sz
    LDR r3, [r5]
	ADDS r3, #1
loop SUBS r3, #1 ;decrementing size
	 MOVS r0, #0 ; whether a swap occurred
	 LDR r4, =arr ;reset ARRAY
	 MOVS r7, #1 ; reset counter
loop1 LDR r6,[r4]
	  LDR r1,[r4,#4]
	  CMP r6, r1
	  BLT skip
	  STR r6, [r4,#4]
	  STR r1, [r4]
	  MOVS r0, #1

skip  ADDS r4, #4;increment array
	  ADDS r7,#1
	  CMP r7,r3 ; compare counter w/ size
	
	  BLT loop1
	  
	  CMP r0, #1
	  BEQ loop
	  
	  LDR r3, [r5]
	  LSRS r3, r3, #1
	  LDR r4, =arr
	  ;HALFWAY LOOP
	  MOVS r6, #1;
half  CMP r6,r3
      BEQ halfdone
	  ADDS r4,#4
	  ADDS r6, #1
	  B half
	  
halfdone	  LDR r0, =arr ; put min into r0 MINIMUM
			  LDR r0, [r0]
			  LDR r1,[r4] ; put mid into r3   
			  ;LDR r4, =arr ; put min into r0 MINIMUM
			  ;LDR r0, [r4]
			  SUBS r5, #4 ; 
			  LDR r2, [r5] ;put max into r2
	 
	 bx lr 
	ENDP
;------------------------------------------------


		ALIGN
		AREA str_dest, DATA, READWRITE
arr		DCD		1,12,20,-15,36,4096,78,-2789,-68
arr_sz	DCD		9

	
	END
		
