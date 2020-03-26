all: compile
	@lua5.3 bin/main.o
	@echo "Running A.G..."
compile:
	@luac5.3 -o bin/base.o src/base.lua
	@luac5.3 -o bin/main.o src/main.lua

libs:
	sudo apt install liblua5.3-dev libglfw3-dev

clean:
	@rm bin/*.o
	@echo "Cleaned!"
