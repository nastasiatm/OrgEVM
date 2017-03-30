DELAY equ 50000
DELAY_H equ 0x3c
DELAY_L equ 0xb0

cseg at 0
	jmp Main

cseg at 0x0b
	jmp Timer0Int
	
dseg at 8h
	counter: ds 1
	M: ds 1
	S: ds 1
	Stack: // defines the stack begin

cseg

Timer0Int:
	push acc // saving regs
	push PSW
	
	mov TH0, #DELAY_H // restarting timer
	mov TL0, #DELAY_L

	inc counter // As we have a 1/20 sec delay,
	mov a, counter // we need to count 20 times before inc seconds
	subb a, #20
	jnz __end
	mov counter, 0

	inc S // increment seconds
	mov a, S
	subb a, #60 // minute passed
	jnz __end
	mov S, 0

	inc M

__end:
	pop PSW
	pop acc
	reti

InitTimer:
	mov TMOD, #1 // 16-bit timer
	setb ET0 // timer 0 interrupt enebled
	setb EA // interrupts enabled
	setb TR0 // timer 0 run
	ret

D2BCD: // Converts to bcd format
	push b
	mov b, #10
	div ab
	swap a
	add a, b
	pop b
	ret

Main:
	mov SP, #Stack // set up stack
	call InitTimer // init timer

__loop:
	mov a, S // sending M and S to ports
	call D2BCD
	mov P1, a
	mov a, M
	call D2BCD
	mov P2, a

	jmp __loop
end