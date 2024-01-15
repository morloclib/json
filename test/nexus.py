#!/usr/bin/env python3

import json
import subprocess
import sys


def usage():
    print("The following commands are exported:")
    print("  foo")
    print('''    param 1: @*x8_e0_x11''')
    print('''    return: @*o_12''')



def call_foo(*args):
    if len([*args]) != 1:
        sys.exit("Expected 1 arguments to 'foo', given " + str(len([*args])))
    else:
        subprocess.run(["./pool-cpp.out", "13", *args])


command_table = {"foo" : call_foo}

def dispatch(cmd, *args):
    if(cmd in ["-h", "--help", "-?", "?"]):
        usage()
    else:
        command_table[cmd](*args)

if __name__ == '__main__':
    if len(sys.argv) == 1:
        usage()
    else:
        cmd = sys.argv[1]
        args = sys.argv[2:]
        dispatch(cmd, *args)
