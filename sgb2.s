SECTION "main",rom0
	; set up stack
	ld sp,$fffe

	ld a,$30
	ld [$ff00],a

	; clear vram ($8000–9fff)
	xor a
	ld hl,$9fff
vloop:
	ld [hld],a
	bit 7,h
	jr nz,vloop

	; set up audio
	ld hl,$ff26
	ld c,$11
	ld a,$80
	ld [hld],a
	ld [$ff00+c],a
	inc c
	ld a,$f3
	ld [$ff00+c],a
	ld [hld],a
	ld a,$77
	ld [hl],a

	; set background palette
	ld a,%11111100
	ld [$ff47],a
	ld hl,$c05f
	ld c,8
	xor a
loop2b:
	ld [hld],a
	dec c
	jr nz,loop2b

	ld de,$014f
	ld a,$fb
	ld c,6
loop36:
	push af
	ld b,0
loop39:
	ld a,[de]
	dec de
	ld [hld],a
	add b
	ld b,a
	dec c
	jr nz,loop39

	ld [hld],a
	pop af
	ld [hld],a
	ld c,$e
	sub 2
	cp $ef
	jr nz,loop36

	; convert and load logo data from cart into vram
	ld de,$0104
	ld hl,$8010
lloop:
	ld a,[de]
	call Graphics
	call Graphics2
	inc de
	ld a,e
	cp $34
	jr nz,lloop

	; load 8 additional bytes into vram
	ld de,registered
	ld b,registered_ - registered
eloop:
	ld a,[de]
	inc de
	ld [hli],a
	inc hl
	dec b
	jr nz,eloop

	; set background tilemap
	ld a,$19
	ld [$9910],a
	ld hl,$992f
oloop:
	ld c,$0c
iloop:
	dec a
	jr z,scroll
	ld [hld],a
	dec c
	jr nz,iloop
	ld l,$f
	jr oloop
scroll:
	; turn on lcd (showing background)
	ld a,$91
	ld [$ff40],a
	ld hl,$c000
	ld c,0
loop89:
	ld a,0
	ld [$ff00+c],a
	ld a,$30
	ld [$ff00+c],a
	ld b,$10
loop91:
	ld e,8
	ld a,[hli]
	ld d,a
loop95:
	bit 0,d
	ld a,$10
	jr nz,loop9d
	ld a,$20
loop9d:
	ld [$ff00+c],a
	ld a,$30
	ld [$ff00+c],a
	rr d
	dec e
	jr nz,loop95
	dec b
	jr nz,loop91
	ld a,$20
	ld [$ff00+c],a
	ld a,$30
	ld [$ff00+c],a
	call funcc2
	ld a,l
	cp $60
	jr nz,loop89
	ld c,$13
	ld a,$c1
	ld [$ff00+c],a
	inc c
	ld a,7
	ld [$ff00+c],a
	jr end
funcc2:
	ld d,4
loopc4:
	ld a,[$ff44]
	cp $90
	jr nz,loopc4
	ld e,0
loopcc:
	dec e
	jr nz,loopcc
	dec d
	jr nz,loopc4
	ret
Graphics:
	ld c,a
Graphics2:
	ld b,4
loopd6:
	push bc
	rl c
	rla
	pop bc
	rl c
	rla
	dec b
	jr nz,loopd6
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	ret

registered:
INCBIN "®.bin"
registered_:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
end:
	ld a,-1
	ld [$ff50],a ; turn off bootrom
