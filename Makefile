run:
	luac5.3 -o bin/main.bin src/main.lua
	lua5.3 bin/main.bin

evolve:
	luac5.3 src/base.lua

libs:
	sudo apt install mesa-utils libglew-dev liblua5.3-dev libglfw3-dev

clean:
	rm bin/*