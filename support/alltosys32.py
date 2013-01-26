#!/usr/bin/env python

import re

print("""%define    stdin   0
%define stdout  1
%define stderr  2
""")

rex = re.compile("define\s+(\S+)\s+(\d+)")

with open("/usr/include/sys/syscall.h") as f:
    calls = f.readlines()

allcall = []

for line in calls:
    result = rex.search(line) 
    if result:
        num = result.group(2)
        name = result.group(1)
        name = name[4:]
        allcall.append(name)
        spacer = " " * (35 - len(name))
        print("%%define SYS_%s%s%s" % (name,spacer,num))

print( """
%macro  system_call  1
    mov eax, %1
    push dword 0
    int 0x80
    add esp, 4
%endmacro
""")


for name in allcall:
    print("""%%macro sys.%s 0
    system_call SYS_%s
%%endmacro
""" % (name,name))

