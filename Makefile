.SUFFIXES: .s .o .bin

all: dmg0.bin dmg.bin mgb.bin sgb.bin sgb2.bin stadium_mgb.bin stadium_cgb.bin

.s.o:
	rgbasm -o $@ $<

.o.bin:
	rgblink -o $@ $<

stadium_mgb.bin: stadium_mgb.o
	rgblink -o $@ $<
	rgbfix -f hl $@

stadium_cgb.bin: stadium_cgb.o
	rgblink -o $@ $<
	rgbfix -f hl $@

clean:
	rm -f *.o *.bin
