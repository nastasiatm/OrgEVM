#include <reg51.h>

unsigned int code tt=0x10000-50000; 
unsigned char th,tl; 

unsigned char sec,min; 
unsigned char count=0;

intt0() interrupt 1  { 
	TL0 = tl; 
	TH0 = th;
	count++; 
	if(count == 20) {
		sec++;
		count = 0;
	}
	if(sec == 60) {
		min++;
	  sec=0;
	} 
}

main() {
	tl = tt & 0xff;
	th = tt >> 8; 
	TMOD = 1; 
	ET0 = 1; 
	TR0 = 1; 
	EA = 1; 
	
	while(1) {
		P1=sec;
		P2=min;
	}
}