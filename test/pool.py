#!/usr/bin/env python

import sys
import subprocess
import json
from pymorlocinternals import (mlc_serialize, mlc_deserialize)
from collections import OrderedDict

sys.path = ["/home/z/.morloc/src/morloc"] + sys.path

from foo import *

def _morloc_foreign_call(args):
    try:
        sysObj = subprocess.run(
            args,
            stdout=subprocess.PIPE,
            check=True
        )
    except subprocess.CalledProcessError as e:
        sys.exit(str(e))

    return(sysObj.stdout.decode("ascii"))

def m8(s0):
    n1 = mlc_deserialize(s0, ("str",None))
    n0 = n1
    n2 = pyfoo(n0)
    s3 = mlc_serialize(n2, ("str",None))
    return(s3)

if __name__ == '__main__':
    try:
        cmdID = int(sys.argv[1])
    except IndexError:
        sys.exit("Internal error in {}: no manifold id found".format(sys.argv[0]))
    except ValueError:
        sys.exit("Internal error in {}: expected integer manifold id".format(sys.argv[0]))
    try:
        dispatch = {
            8: m8,
        }
        __mlc_function__ = dispatch[cmdID]
    except KeyError:
        sys.exit("Internal error in {}: no manifold found with id={}".format(sys.argv[0], cmdID))

    __mlc_result__ = __mlc_function__(*sys.argv[2:])

    if __mlc_result__ != "null":
        print(__mlc_result__)
