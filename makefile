ENGINE = engine
NAME = simon
SRCPATH = src/

any:
	rgbasm -o $(NAME).o $(SRCPATH)$(ENGINE).asm
	rgblink -o $(NAME).gb $(NAME).o
	rgbfix $(NAME).gb -p 255 -v


run:
	wine /home/nepecute/bgb/bgb64.exe ./$(NAME).gb

clean:
	rm *.o
mrproper:
	rm *.o *.gb
