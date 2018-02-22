.SUFFIXES: .s .o .bin

all: dmg0.bin dmg.bin mgb.bin sgb.bin sgb2.bin

.s.o:
	rgbasm -o $@ $<

.o.bin:
	rgblink -o $@ $<

clean:
	rm -f *.o *.bin
