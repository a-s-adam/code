
__asm void to_lowercase(char* str)
{

loop1	LDRB r4, [r0]
			CMP r4, #0
		  BEQ exit
			CMP r4, #32 //space bar
			BEQ loop2
	    CMP r4, #96 // send to already lowercase
	    BGT loop2
	
			ADDS r4, #20 // UPPERcase TO LOWERcase LOOP
			STRB r4, [r3]
			ADDS r0, #1
			ADDS r3, #1
		B   loop1
	
loop2 STRB r4, [r3]  // ALREADY LOWERcase LOOP
			ADDS r0, #1
			ADDS r3, #1
		B   loop1
	
exit MOVS r4, #0


}

int main(void) {
	
	char data[] = "IdE A NOStRE bO LIS TU MANoRE";
	to_lowercase(data);
	
	while(1) {}
	
	
}
