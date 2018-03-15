include "mgb.s"

SECTION "header",rom0[$100]
start:
	jr start
	nop
	nop

	ds $3c
