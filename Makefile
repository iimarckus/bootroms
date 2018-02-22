.SUFFIXES: .s .o .bin

all: dmg.bin mgb.bin

.s.o:
	rgbasm -o $@ $<

.o.bin:
	rgblink -o $@ $<

clean:
	rm -f *.o *.bin
