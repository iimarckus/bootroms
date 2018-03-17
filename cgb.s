SECTION "main",rom0

	ld sp,$FFFE
	ld a,2
	jp func7c

dma: MACRO
	db HIGH(\1),LOW(\1),HIGH(\2),LOW(\2),(\3-1)/$10
ENDM
DMAdata:
	dma $D300,$98A0,$130
	dma $D300,$8000,$410

ManualSelectPalettes:
	db $1E,$53,$D0,$00
	db $1F,$42,$1c,$00
	db $14,$2A,$4D,$19
	db $8C,$7E,$00,$7c
	db $31,$6E,$4A,$45
	db $52,$4A,$00,$00
	db $FF,$53,$1F,$7C
	db $FF,$03,$1F,$00
	db $FF,$1F,$A7,$00
	db $EF,$1B,$1F,$00
	db $EF,$1B,$00,$7c
	db $00,$00,$ff,$03

logo:
INCBIN "nintendo.s"

registered:
INCBIN "®.bin"
registered_:

data7a:
	db $58,$43

func7c:
	ld [$ff70],a
	ld a,$fc
	ld [$ff47],a
	call $0275
	call $0200
	ld h,$d0
	call $0203
	ld hl,$fe00
	ld c,$a0
	xor a
loop93:
	ld [hli],a
	dec c
	jr nz,loop93
	ld de,$0104
	ld hl,$8010
	ld c,h
loop9e:
	ld a,[de]
	ld [$ff00+c],a
	inc c
	call $03c6
	call $03c7
	inc de
	ld a,e
	cp $34
	jr nz,loop9e
	ld de,registered
	ld b,registered_ - registered
funcb2:
	ld a,[de]
	inc de
	ld [hli],a
	inc hl
	dec b
	jr nz,funcb2
	call $03f0
	ld a,$01
	ld [$ff4f],a
	ld a,$91
	ld [$ff40],a
	ld hl,$98b2
	ld b,$4e
	ld c,$44
	call $0291
	xor a
	ld [$ff4f],a
	ld c,$80
	ld hl,$0042
	ld b,$18
loopd8:
	ld a,[$ff00+c]
	inc c
	cp [hl]
infloop1:
	jr nz,infloop1
	inc hl
	dec b
	jr nz,loopd8
	ld hl,$0134
	ld b,$19
	ld a,b
loope7:
	add [hl]
	inc l
	dec b
	jr nz,loope7
	add [hl]
infloop2:
	jr nz,infloop2
	call $031c
	jr .next
	nop
	nop
.next
	call $05d0
	xor a
	ld [$ff70],a
	ld a,$11
	ld [$ff50],a

SEcTION "more",rom0[$200]
func200:
	ld hl,$8000
	xor a
loop204:
	ld [hli],a
	bit 5,h
	jr z,loop204
	ret

func20a:
	ld a,[hli]
	ld [de],a
	inc de
	dec c
	jr nz,func20a
	ret

func211:
	push hl
	ld hl,$ff0f
	res 0,[hl]
.prev
	bit 0,[hl]
	jr z,.prev
	pop hl
	ret

func21d:
	ld de,$ff00
	ld hl,$d003
	ld c,$0f
	ld a,$30
	ld [de],a
	ld a,$20
	ld [de],a
	ld a,[de]
	cpl
	and c
	swap a
	ld b,a
	ld a,$10
	ld [de],a
	ld a,[de]
	cpl
	and c
	or b
	ld c,a
	ld a,[hl]
	xor c
	and $f0
	ld b,a
	ld a,[hli]
	xor c
	and c
	or b
	ld [hld],a
	ld b,a
	ld a,c
	ld [hl],a
	ld a,$30
	ld [de], a
	ret

func24a:
	ld a,$80
	ld [$ff68],a
	ld [$ff6a],a
	ld c,$6b
.loop1
	ld a,[hli]
	ld [$ff00+c],a
	dec b
	jr nz,.loop1
	ld c,d
	add hl,bc
	ld b,e
	ld c,$69
.loop2
	ld a,[hli]
	ld [$ff00+c],a
	dec b
	jr nz,.loop2
	ret

func262:
	push bc
	push de
	push hl
	ld hl,$d800
	ld b,1
	ld d,$3f
	ld e,$40
	call $24a
	pop hl
	pop de
	pop bc
	ret

func275:
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
.loop
	ld [hli],a
	cpl
	dec c
	jr nz,.loop
	ret

func291:
	call func211
	call func262
	ld a,c
	cp $38
	jr nz,.next
	push hl
	xor a
	ld [$ff4f],a
	ld hl,$99a7
	ld a,$38
.loop1
	ld [hli],a
	inc a
	cp $3f
	jr nz,.loop1
	ld a,$01
	ld [$ff4f],a
	pop hl
.next
	push bc
	push hl
	ld hl,$0143
	bit 7,[hl]
	call z,$0589
	pop hl
	pop bc
	call func211
	ld a,c
	sub $30
	jp nc,$0306
	ld a,c
	cp $01
	jp z,$0306
	ld a,l
	cp $d1
	jr z,.next2
	push bc
	ld b,$03
.loopc
	ld c,$01
.loopb
	ld d,$03
.loopa
	ld a,[hl]
	and $f8
	or c
	ld [hli],a
	dec d
	jr nz,.loopa
	inc c
	ld a,c
	cp $06
	jr nz,.loopb
	ld de,$0011
	add hl,de
	dec b
	jr nz,.loopc
	ld de,$ffa1
	add hl,de
	pop bc
.next2
	inc b
	ld a,b
	ld e,$83
	cp $62
	jr z,.next3
	ld e,$c1
	cp $64
	jr nz,func306
.next3
	ld a,e
	ld [$ff13],a
	ld a,$87
	ld [$ff14],a
func306:
	ld a,[$d002]
	cp $00
	jr z,.next4
	dec a
	ld [$d002],a
	ld a,c
	cp $01
	jp z,func291
.next4
	dec c
	jp nz,func291
	ret

func31c:
	ld c,$26
.loop
	call func34a
	call func211
	call func262
	dec c
	jr nz,.loop
	call func211
	ld a,1
	ld [$ff4f],a
	call $33e
	call $341
	xor a
	ld [$ff4f],a
	call $33e
	ret

func33e:
	ld hl,8
	ld de,$ff51
	ld c,5
	call $20a
	ret

func34a:
	push bc
	push de
	push hl
	ld hl,$d840
	ld c,$20
.loop
	ld a,[hl]
	and $1f
	cp $1f
	jr z,.next1
	inc a
.next1
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
	jr z,.next2
	inc a
.next2
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
	jr z,.next3
	inc a
.next3
	rlca
	rlca
	or e
	ld [hli],a
	dec c
	jr nz,.loop
	pop hl
	pop de
	pop bc
	ret

func38f:
	ld c,0
.loop
	ld a,[de]
	and $f0
	bit 1,c
	jr z,.next1
	swap a
.next1
	ld b,a
	inc hl
	ld a,[hl]
	or b
	ld [hli],a
	ld a,[de]
	and $f
	bit 1,c
	jr nz,.next2
	swap a
.next2
	ld b,a
	inc hl
	ld a,[hl]
	or b
	ld [hli],a
	inc de
	bit 0,c
	jr z,.next3
	push de
	ld de,$fff8
	bit 1,c
	jr z,.next4
	ld de,8
.next4
	add hl,de
	pop de
.next3
	inc c
	ld a,c
	cp $18
	jr nz,.loop
	ret

func3c6:
	ld b,a
	push de
	ld d,4
.loop
	ld e,b
	rl b
	rla
	rl e
	rla
	dec d
	jr nz,.loop
	pop de
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	ret

func3da:
	ld a,$19
	ld [$9910],a
	ld hl,$992f
.loop2
	ld c,$c
.loop1
	dec a
	jr z,.done
	ld [hld],a
	dec c
	jr nz,.loop1
	ld l,$f
	jr .loop2
.done
	ret

func3f0:
	ld a,$01
	ld [$ff4f],a
	call $0200
	ld de,$0607
	ld hl,$8080
	ld c,$c0
.loop1
	ld a,[de]
	ld [hli],a
	inc hl
	ld [hli],a
	inc hl
	inc de
	dec c
	jr nz,.loop1
	ld de,$0104
	call $038f
	ld bc,$ffa8
	add hl,bc
	call $038f
	ld bc,$fff8
	add hl,bc
	ld de,$0072
	ld c,$08
.loop2
	inc hl
	ld a,[de]
	ld [hli],a
	inc de
	dec c
	jr nz,.loop2
	ld hl,$98c2
	ld b,$08
	ld a,$08
.loop4
	ld c,$10
.loop3
	ld [hli],a
	dec c
	jr nz,.loop3
	ld de,$0010
	add hl,de
	dec b
	jr nz,.loop4
	xor a
	ld [$ff4f],a
	ld hl,$98c2
	ld a,$08
.loop5
	ld [hli],a
	inc a
	cp $18
	jr nz,.skip1
	ld l,$e2
.skip1
	cp $28
	jr nz,.skip2
	ld hl,$9902
.skip2
	cp $38
	jr nz,.loop5
	ld hl,$08d8
	ld de,$d840
	ld b,$08
.loop6
	ld a,$ff
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld c,$02
	call $020a
	ld a,$00
	ld [de],a
	inc de
	ld [de],a
	inc de
	inc de
	inc de
	dec b
	jr nz,.loop6
	call func262
	ld hl,$014b
	ld a,[hl]
	cp $33
	jr nz,.a_488
	ld l,$44
	ld e,$30
	ld a,[hli]
	cp e
	jr nz,.a_4ce
	inc e
	jr .a_48c
.a_488
	ld l,$4b
	ld e,$01
.a_48c
	ld a,[hli]
	cp e
	jr nz,.a_4ce
	ld l,$34
	ld bc,$0010
.a_495
	ld a,[hli]
	add b
	ld b,a
	dec c
	jr nz,.a_495
	ld [$d000],a
	ld hl,$06c7
	ld c,$00
.a_4a3
	ld a,[hli]
	cp b
	jr z,.a_4af
	inc c
	ld a,c
	cp $4f
	jr nz,.a_4a3
	jr .a_4ce
.a_4af
	ld a,c
	sub $41
	jr c,.a_4d0
	ld hl,$0716
	ld d,$00
	ld e,a
	add hl,de
.a_4bb
	ld a,[$0137]
	ld d,a
	ld a,[hl]
	cp d
	jr z,.a_4d0
	ld de,$000e
	add hl,de
	ld a,c
	add e
	ld c,a
	sub $5e
	jr c,.a_4bb
.a_4ce
	ld c,$00
.a_4d0
	ld hl,$0733
	ld b,$00
	add hl,bc
	ld a,[hl]
	and $1f
	ld [$d008],a
	ld a,[hl]
	and $e0
	rlca
	rlca
	rlca
	ld [$d00b],a
	call $04e9
	ret

func4e9:
	ld de,$0791
	ld hl,$d900
	ld a,[$d00b]
	ld b,a
	ld c,$1e
.loop
	bit 0,b
	jr nz,.a_4fb
	inc de
	inc de
.a_4fb
	ld a,[de]
	ld [hli],a
	jr nz,.a_501
	dec de
	dec de
.a_501
	bit 1,b
	jr nz,.a_507
	inc de
	inc de
.a_507
	ld a,[de]
	ld [hli],a
	inc de
	inc de
	jr nz,.a_50f
	dec de
	dec de
.a_50f
	bit 2,b
	jr z,.a_518
	dec de
	dec hl
	ld a,[de]
	ld [hli],a
	inc de
.a_518
	ld a,[de]
	ld [hli],a
	inc de
	dec c
	jr nz,.loop
	ld hl,$d900
	ld de,$da00
	call $0564
	ret

func528:
	ld hl,ManualSelectPalettes
	ld a,[$d005]
	rlca
	rlca
	ld b,$00
	ld c,a
	add hl,bc
	ld de,$d840
	ld b,$08
.loop
	push hl
	ld c,$02
	call $020a
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	pop hl
	dec b
	jr nz,.loop
	ld de,$d842
	ld c,$02
	call $020a
	ld de,$d84a
	ld c,$02
	call $020a
	dec hl
	dec hl
	ld de,$d844
	ld c,$02
	call $020a
	ret

func564:
	ld c,$60
.loop
	ld a,[hli]
	push hl
	push bc
	ld hl,$07e8
	ld b,$00
	ld c,a
	add hl,bc
	ld c,$08
	call $020a
	pop bc
	pop hl
	dec c
	jr nz,.loop
	ret

func57b:
	ld a,[$d008]
	ld de,$0018
	inc a
.loop
	dec a
	jr z,.done
	add hl,de
	jr nz,.loop
.done
	ret

func589:
	call $021d
	ld a,b
	and $ff
	jr z,.a_5a0
	ld hl,$08e4
	ld b,$00
.loop
	ld a,[hli]
	cp c
	jr z,.a_5a2
	inc b
	ld a,b
	cp $0c
	jr nz,.loop
.a_5a0
	jr .done
.a_5a2
	ld a,b
	ld [$d005],a
	ld a,$1e
	ld [$d002],a
	ld de,$000b
	add hl,de
	ld d,[hl]
	ld a,d
	and $1f
	ld e,a
	ld hl,$d008
	ld a,[hld]
	ld [hli],a
	ld a,e
	ld [hl],a
	ld a,d
	and $e0
	rlca
	rlca
	rlca
	ld e,a
	ld hl,$d00b
	ld a,[hld]
	ld [hli],a
	ld a,e
	ld [hl],a
	call $04e9
	call $0528
.done
	ret

func5d0:
	call func211
	ld a,[$0143]
	bit 7,a
	jr z,.next
	ld [$ff4c],a
	jr .done
.next
	ld a,$04
	ld [$ff4c],a
	ld a,$01
	ld [$ff6c],a
	ld hl,$da00
	call $057b
	ld b,$10
	ld d,$00
	ld e,$08
	call $024a
	ld hl,data7a
	ld a,[$d000]
	ld b,a
	ld c,$02
.loop
	ld a,[hli]
	cp b
	call z,$03da
	dec c
	jr nz,.loop
.done
	ret
