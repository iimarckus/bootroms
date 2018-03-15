SECTION "main",rom0
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
	ld a,%11111100
	ld [$ff47],a

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
	ld de,moredata
	ld b,moredata_ - moredata
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
	; initialize scroll count
	ld h,a

	; set loop count and vertical scroll register
	ld a,$64
	ld d,a
	ld [$ff42],a

	; turn on lcd (showing background)
	ld a,$91
	ld [$ff40],a
	inc b

sloop:
	ld e,2
floop1:
	ld c,$c
floop2:
	ld a,[$ff44]
	cp $90 ; wait for screen frame
	jr nz,floop2
	dec c
	jr nz,floop2
	dec e
	jr nz,floop1

	ld c,$13
	inc h ; increment scroll count
	ld a,h
	ld e,$83
	cp $62 ; 62 counts in, play sound #1
	jr z,sound1
	ld e,$c1
	cp $64
	jr nz,sound2 ; 64 counts in, play sound #2
sound1:
	ld a,e
	ld [$ff00+c],a
	inc c
	ld a,$87
	ld [$ff00+c],a
sound2:
	ld a,[$ff42]
	sub b
	ld [$ff42],a ; scroll logo up if b=1
	dec d
	jr nz,sloop

	dec b ; set b=0 first time
	jr nz,logocheck ; … next time, cause jump to logo check

	ld d,$20 ; use scrolling loop to pause
	jr sloop

Graphics:
	ld c,a ; “double up” all the bits of the graphics data, store it in vram
Graphics2:
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

logo:
	db $ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	db $00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	db $bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

moredata:
	db $3c,$42,$b9,$a5,$b9,$a5,$42,$3c
moredata_:

logocheck:
	ld hl,$0104 ; cart logo
	ld de,logo

lastbranch:
	ld a,[de]
	inc de
	cp [hl] ; compare cart logo to bootrom logo
llockup:
	jr nz,llockup
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
clockup:
	jr nz,clockup
	ld a,1
	ld [$ff50],a ; turn off bootrom
