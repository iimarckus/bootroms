.SUFFIXES: .s .o .bin

all: dmg0.bin dmg.bin mgb.bin

.s.o:
	rgbasm -o $@ $<

.o.bin:
	rgblink -o $@ $<

clean:
	rm -f *.o *.bin
