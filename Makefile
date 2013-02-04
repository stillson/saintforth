# $Id: Makefile,v 1.9 2007-10-22 18:53:12 rich Exp $

#BUILD_ID_NONE := -Wl,--build-id=none 
BUILD_ID_NONE := 

SHELL	:= /bin/sh

all:	stforth

stforth: stforth.S nasm-sys32.inc
	nasm -g -f elf32 stforth.S -o stforth.o
	ld -N -Ttext 0x1000 -M -m elf_i386_fbsd stforth.o -o stforth > diag/stforth.map

nasm-sys32.inc: support/alltosys32.py
	support/alltosys32.py > nasm-sys32.inc

diag::
	nasm -e -g -f elf32 stforth.S -o diag/stforth.pp
	objdump -x -d stforth > diag/stforth.dis
	nm stforth > diag/stforth.syms

clean:
	rm -f stforth stforth.o stforth.core diag/* perf_dupdrop *~ .test_*


perf_dupdrop: perf_dupdrop.c
	gcc -O3 -Wall -Werror -o $@ $<

run_perf_dupdrop: jonesforth
	cat <(echo ': TEST-MODE ;') jonesforth.f perf_dupdrop.f | ./jonesforth

