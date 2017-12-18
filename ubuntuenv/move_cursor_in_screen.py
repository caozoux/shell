#!/usr/bin/env python3
import subprocess
import sys

arg = sys.argv[1]

screeninfo = [
    s for s in subprocess.check_output("xrandr").decode("utf-8").split()\
    if s.count("+") == 2
    ]

if arg == "left":
    match = [s for s in screeninfo if s.endswith("+0+0")][0]
elif arg == "right":
    match = [s for s in screeninfo if not s.endswith("+0+0")][0]

data = [item.split("x") for item in match.split("+")]
numbers = [int(n) for n in [item for sublist in data for item in sublist]]
coord = [str(int(n)) for n in [(numbers[0]/2)+numbers[2], (numbers[1]/2)+numbers[3]]]

subprocess.Popen(["xdotool", "mousemove", coord[0], coord[1]])
