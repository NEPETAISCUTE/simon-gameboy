ENGINE = engine
NAME = simon

any:
	rgbasm -o $(NAME).o $(ENGINE).asm
	rgblink -o $(NAME).gb $(NAME).o
	rgbfix $(NAME).gb -p 255 -v
	
