.SUFFIXES: .s .o .bin .png

all: dmg0.bin dmg.bin mgb.bin sgb.bin sgb2.bin stadium_mgb.bin stadium_cgb.bin cgb.bin

.s.o:
	rgbasm -o $@ $<

.o.bin:
	rgblink -o $@ $<

.png.bin:
	rgbgfx -d 1 -o $@ $<

stadium_mgb.bin: stadium_mgb.o
	rgblink -o $@ $<
	rgbfix -f hl $@

stadium_cgb.bin: stadium_cgb.o
	rgblink -o $@ $<
	rgbfix -f hl $@

dmg0.o: nintendo.s
dmg.o: ®.bin nintendo.s
mgb.o: ®.bin nintendo.s
cgb.o: ®.bin nintendo.s
sgb.o: ®.bin
sgb2.o: ®.bin
stadium_mgb.o: ®.bin nintendo.s
stadium_cgb.o: ®.bin nintendo.s

clean:
	rm -f *.o *.bin
