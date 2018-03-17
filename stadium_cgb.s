SECTION "main",rom0
	; set up stack
	ld sp,$fffe

	ld a,$80
	ld [$ff68],a
	ld c,$69
	xor a
	ld b,$40
loop:
	ld [$ff00+c],a
	dec b
	jr nz,loop
	jp part2

data13:
	db $d3,$00,$98,$a0,$12

data18:
	db $d3,$00,$80,$00,$40

registered:
INCBIN "®.bin"
registered_:

part2:
	ld [$ff40],a

	; set background palette
	ld a,%11111100
	ld [$ff47],a

	call $0097
	call $0086
	ld h,$d0
	call $0089
	ld hl,$fe00
	ld c,$a0
	xor a
loop2:
	ld [hli],a
	dec c
	jr nz,loop2

	ld de,$0104
	ld hl,$8010
	ld c,h
loop3:
	ld a,[de]
	ld [$ff00+c],a
	inc c
	call $0270
	call $0271
	inc de
	ld a,e
	cp $34
	jr nz,loop3

	ld de,registered
	ld b,registered_ - registered
loop4:
	ld a,[de]
	inc de
	ld [hli],a
	inc hl
	dec b
	jr nz,loop4

	call $029a
	ld a,$01
	ld [$ff4f],a
	ld a,$91
	ld [$ff40],a
	ld hl,$98b2
	ld b,$4e
	ld c,$96
	call $017b
	xor a
	ld [$ff4f],a
	call $01fa
	jr next
next:
	call $00ea
	ld [$ff50],a
lockup:
	jr lockup

func86:
	ld hl,$8000
	xor a
loop86:
	ld [hli],a
	bit 5,h
	jr z,loop86
	ret

func90:
	ld a,[hli]
	ld [de],a
	inc de
	dec c
	jr nz,func90
	ret

func97:
	ld a,$80
	ld [$ff26],a
	ld [$ff11],a
	ld a,$f3
	ld [$ff12],a
	ld [$ff25],a
	ld a,$77
	ld [$ff24],a
	ld hl,$ff30
	xor a
	ld c,$10
loop97:
	ld [hli],a
	cpl
	dec c
	jr nz,loop97
	ret

funcb3:
	ld c,$00
funcb5:
	ld a,[de]
	and $f0
	bit 1,c
	jr z,funcbe
	swap a
funcbe:
	ld b,a
	inc hl
	ld a,[hl]
	or b
	ld [hli],a
	ld a,[de]
	and $0f
	bit 1,c
	jr nz,funccc
	swap a
funccc:
	ld b,a
	inc hl
	ld a,[hl]
	or b
	ld [hli],a
	inc de
	bit 0,c
	jr z,funce3
	push de
	ld de,$fff8
	bit 1,c
	jr z,funce1
	ld de,$0008
funce1:
	add hl,de
	pop de
funce3:
	inc c
	ld a,c
	cp $18
	jr nz,funcb5
	ret
	push hl
	ld hl,$ff0f
	res 0,[hl]
prejump:
	bit 0,[hl]
	jr z,prejump
	pop hl
	ret

SECTION "header",rom0[$100]
	nop
	jp 0

	ds $3c

SECTION "body",rom0[$150]
start:
	ld a,$80
	ld [$ff68],a
	ld [$ff6a],a
	ld c,$6b
loop158:
	ld a,[hli]
	ld [$ff00+c],a
	dec b
	jr nz,loop158
	ld c,d
	add hl,bc
	ld b,e
	ld c,$69
loop162:
	ld a,[hli]
	ld [$ff00+c],a
	dec b
	jr nz,loop162
	ret
start2:
	push bc
	push de
	push hl
	ld hl,$d800
	ld b,$01
	ld d,$3f
	ld e,$40
	call start
	pop hl
	pop de
	pop bc
	ret
	call $00ea
	call start2
	ld a,c
	cp $77
	jr nz,jump19a
	push hl
	xor a
	ld [$ff4f],a
	ld hl,$99a7
	ld a,$38
loop18f:
	ld [hli],a
	inc a
	cp $3f
	jr nz,loop18f
	ld a,$01
	ld [$ff4f],a
	pop hl
jump19a:
	call $00ea
	ld a,c
	sub $3a
	jp nc,$01e4
	ld a,c
	cp $01
	jp z,$01e4
	ld a,l
	cp $d1
	jr z,jump1cf
	push bc
	ld b,$03
loop1b3:
	ld c,$01
loop1b4:
	ld d,$03
loop1b5:
	ld a,[hl]
	and $f8
	or c
	ld [hli],a
	dec d
	jr nz,loop1b5
	inc c
	ld a,c
	cp $06
	jr nz,loop1b4
	ld de,$0011
	add hl,de
	dec b
	jr nz,loop1b3
	ld de,$ffa1
	add hl,de
	pop bc
jump1cf:
	inc b
	ld a,b
	ld e,$83
	cp $62
	jr z,jump1dd
	ld e,$c1
	cp $64
	jr nz,jump1e4
jump1dd:
	ld a,e
	ld [$ff13],a
	ld a,$87
	ld [$ff14],a
jump1e4:
	ld a,[$d002]
	cp $00
	jr z,jump1f5
	dec a
	ld [$d002],a
	ld a,c
	cp $01
	jp z,$017b
jump1f5:
	dec c
	jp nz,$017b
	ret
	ld c,$26
loop1fc:
	call $022b
	call $00ea
	call $00ea
	call start2
	dec c
	jr nz,loop1fc
	call $00ea
	ld a,$01
	ld [$ff4f],a
	call $021f
	call $0222
	xor a
	ld [$ff4f],a
	call $021f
	ret
	ld hl,data13
	ld de,$ff51
	ld c,$05
	call $0090
	ret
	push bc
	push de
	push hl
	ld hl,$d840
	ld c,$20
func233:
	ld a,[hl]
	and $1f
	cp $1f
	jr z,skip1
	inc a
skip1:
	ld d,a
	ld a,[hli]
	rlca
	rlca
	rlca
	and $07
	ld b,a
	ld a,[hld]
	rlca
	rlca
	rlca
	and $18
	or b
	cp $1f
	jr z,skip2
	inc a
skip2:
	rrca
	rrca
	rrca
	ld b,a
	and $e0
	or d
	ld [hli],a
	ld a,b
	and $03
	ld e,a
	ld a,[hl]
	rrca
	rrca
	and $1f
	cp $1f
	jr z,skip3
	inc a
skip3:
	rlca
	rlca
	or e
	ld [hli],a
	dec c
	jr nz,func233
	pop hl
	pop de
	pop bc
	ret
	ld b,a
	push de
	ld d,$04
loop274:
	ld e,b
	rl b
	rla
	rl e
	rla
	dec d
	jr nz,loop274
	pop de
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	ret
	ld a,$19
	ld [$9910],a
	ld hl,$992f
	ld c,$0c
loop28e:
	dec a
	jr z,skip299
	ld [hld],a
	dec c
	jr nz,loop28e
	ld l,$0f
	jr $f3
skip299:
	ret
	ld a,$01
	ld [$ff4f],a
	call $0086
	ld de,$0320
	ld hl,$8080
	ld c,$c0
loop2a9:
	ld a,[de]
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	inc de
	dec c
	jr nz,loop2a9
	ld de,$0104
	call $00b3
	ld bc,$ffa8
	add hl,bc
	call $00b3
	ld bc,$fff8
	add hl,bc
	ld de,registered
	ld c,registered_ - registered
loop2c8:
	inc hl
	ld a,[de]
	ld [hli],a
	inc de
	dec c
	jr nz,loop2c8
	ld hl,$98c2
	ld b,$08
	ld a,$08
loop2d6:
	ld c,$10
loop2d8:
	ld [hli],a
	dec c
	jr nz,loop2d8
	ld de,$0010
	add hl,de
	dec b
	jr nz,loop2d6
	xor a
	ld [$ff4f],a
	ld hl,$98c2
	ld a,$08
loop2eb
	ld [hli],a
	inc a
	cp $18
	jr nz,skip2f3
	ld l,$e2
skip2f3:
	cp $28
	jr nz,skip30a
	ld hl,$9902
skip30a:
	cp $38
	jr nz,loop2eb
	ld hl,$03e0
	ld de,$d840
	ld b,$08
loop306:
	ld a,$ff
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld c,$02
	call $0090
	ld a,$00
	ld [de],a
	inc de
	ld [de],a
	inc de
	inc de
	inc de
	dec b
	jr nz,loop306
	call start2
	ret
