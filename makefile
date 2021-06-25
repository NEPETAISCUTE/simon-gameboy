ENGINE = engine
NAME = simon

any:
	rgbasm -o $(NAME).o src/$(ENGINE).asm
	rgbasm -o joypad.o src/joypad.asm
	rgbasm -o rng.o src/lib/rng.asm
	rgblink -o $(NAME).gb $(NAME).o joypad.o rng.o
	rgbfix $(NAME).gb -p 255 -v

clean:
	rm *.o
mrproper:
	rm *.o *.gb
