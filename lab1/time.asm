cseg at 0
	jmp Main dseg at 4h

sec: ds 1
min: ds 1
count: ds 1
Tc: ds 1
Tm: ds 1

cseg at 0Bh

EIntT0:
	inc count
	mov a, count
	subb a, #41
	jnz end_tc
	inc sec
	mov count, #0

end_tc:
	mov a, sec
	subb a, #60
	jnz end_tm
	inc min
	mov sec, #0

end_tm:
	reti

Main:
	mov TMOD, #0x1
	setb ET0
	setb TR0
	setb EA

__loop:
	mov P1, sec
	mov P2, min
	mov P3, count
	jmp __loop end