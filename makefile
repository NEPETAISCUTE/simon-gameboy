ENGINE = engine
NAME = simon

any:
	rgbasm -o $(NAME).o src/$(ENGINE).asm
	rgblink -o $(NAME).gb $(NAME).o
	rgbfix $(NAME).gb -p 255 -v



clean:
	rm *.o
mrproper:
	rm *.o *.gb
