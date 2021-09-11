#!env python3
"""
Transforms in stdin the content of a path data to a compressed format used by svgToolbox.sol
the content of <path d="content" ...> is first rounded to int
then transformed to a byte string.
A Q and T are not implemented yet
Rounded values must fit in an uint ; <= 0 and >= 255

Documentation on path:
https://www.w3.org/TR/SVG/paths.html

Version 1.0 2021.09.10 
"""

import sys
import re
import binascii

COMMANDS="MmLlHhVvCcSsQqTtAaZz"

def float2hexuint(f):
    """ rounds a string supposed to be a float """
    i = round(float(f))
    if i > 255 or i < 0:
        raise ValueError("value parameters must be > 0 and < 255")
    return str.encode(f"{i:02x}")


def path2hex(path):
    """ transforms a svg path to a hexa string representation """
    output=b""
    # Extract each command and its parameters
    res = re.compile("([" + COMMANDS + "])").split(path)
    for r in res:
        if r == "":
            continue
        # convert the command in hex string
        if r in COMMANDS:
            if r in "QTAqta":
                raise ValueError("Sorry; 'Q', 'T', 'A', 'q', 't', 'a' are not implemented yet.")
            output += binascii.hexlify(str.encode((r)))
        # converts the parameters to hex string
        else:
            params = r.split()
            for p in params:
                output += float2hexuint(p)
    return(output)


if __name__ == "__main__":
    for line in sys.stdin:
        print(path2hex(line))
