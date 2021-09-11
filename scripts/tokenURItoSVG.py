#!/usr/bin/env python3
"""
Verify and displays for debugging purposes 
the string returned by ERC721.tokenURI(uint)
Fails if an error is encountered.
Version 1.0 2021.09.10
"""

import base64
import json
import sys
from urllib import request
import xml.dom.minidom

def tokenURItoSVG(line, outfile=None):
    # get and decode 'data:application/json;base64'
    data = request.urlopen(line).read()
    data = json.loads(data)
    print("### Metadata ###")
    for k in list(data):
        if k == "image":
            continue
        print(f"{k}: {data[k]}")
    # get image
    svg = request.urlopen(data['image']).read()
    print("### Raw image ###\n", svg)
    # parse image and print it indented
    dom = xml.dom.minidom.parseString(svg)
    print("### Pretty xml ###\n", dom.toprettyxml())
    # try to write in output_file
    if (outfile is True):
        outfile = "/tmp/token_test.svg"
    if (outfile):
        with open(outfile, 'w') as out:
            out.write(svg.decode("utf-8"))


if __name__ == "__main__":
    for line in sys.stdin:
        tokenURItoSVG(line)
