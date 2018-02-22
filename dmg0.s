SECTION "blah",rom0
	; set up stack
	ld sp,$fffe

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
	ld a,$fc
	ld [$ff47],a

	; convert and load logo data from cart into vram
	ld hl,$0104 ; cart logo
	push hl
	ld de,logo

lastbranch:
	ld a,[de]
	inc de
	cp [hl] ; compare cart logo to bootrom logo
	jr nz,loop98
	inc hl
	ld a,l
	cp $34
	jr nz,lastbranch

	ld b,$19
	ld a,b
cloop:
	add [hl]
	inc hl
	dec b
	jr nz,cloop
	add [hl]

	jr nz,loop98
	pop de
	ld hl,$8010
loopf3:
	ld a,[de]
	call funca9
	call funcaa
	inc de
	ld a,e
	cp $34
	jr nz,loopf3
	ld a,$18
	ld hl,$992f
loopf1:
	ld c,$c
loop56:
	ld [hld],a
	dec a
	jr z,loop09
	dec c
	jr nz,loop56
	ld de,$ffec
	add hl,de
	jr loopf1
loop09:
	ld h,a
	ld a,$64
	ld d,a
	ld [$ff42],a
	ld a,$91
	ld [$ff40],a
	inc b
loop6e:
	ld e,2
	call funcbc
	ld c,$13
	inc h
	ld a,h
	ld e,$83
	cp $62
	jr z,loop83
	ld e,$c1
	cp $64
	jr nz,loop89
loop83:
	ld a,e
	ld [$ff00+c],a
	inc c
	ld a,$87
	ld [$ff00+c],a
loop89:
	ld a,[$ff42]
	sub b
	ld [$ff42],a
	dec d
	jr nz,loop6e
	dec b
	jr nz,end
	ld d,$20
	jr loop6e
loop98:
	ld a,$91
	ld [$ff40],a
loop9c:
	ld e,$14
	call funcbc
	ld a,[$ff47]
	xor $ff
	ld [$ff47],a
	jr loop9c
funca9:
	ld c,a
funcaa:
	ld b,4

dloop:
	push bc
	rl c
	rla
	pop bc
	rl c
	rla
	dec b
	jr nz,dloop
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	ret
funcbc:
	ld c,$c
loopbe:
	ld a,[$ff44]
	cp $90
	jr nz,loopbe
	dec c
	jr nz,loopbe
	dec e
	jr nz,funcbc
	ret

logo:
	db $ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	db $00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	db $bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

	db $ff,$ff

end:
	inc a
	ld [$ff50],a ; turn off bootrom
