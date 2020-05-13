all: compile
	@lua5.3 bin/main.o
	@echo "Running A.G..."
compile:
	@luac5.3 -o bin/base.o src/base.lua
	@luac5.3 -o bin/main.o src/main.lua

INSTALL_COMPONENTS:
	sudo apt install lua5.3 libfltk1.3-dev
	sudo chmod a+x install_libs_aux.sh
	./install_libs_aux.sh
clean:
	@rm bin/*.o
	@echo "Cleaned!"
