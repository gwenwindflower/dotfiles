#!/usr/bin/env python3
"""Add a themed gradient background (with subtle grain) behind a termframe SVG.

Usage: termframe-bg.py capture.svg [-o out.svg] [--from HEX] [--to HEX]
       [--mid HEX] [--rx PX] [--grain 0..1] [--angle DEG]
"""

import argparse
import math
import re
import sys
from pathlib import Path

DEFAULTS = {
    "from": "#f4b8e4",  # catppuccin frappe pink
    "mid": "#ca9ee6",   # mauve
    "to": "#8caaee",    # blue
}


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("svg", type=Path)
    p.add_argument("-o", "--output", type=Path)
    p.add_argument("--from", dest="c_from", default=DEFAULTS["from"])
    p.add_argument("--mid", dest="c_mid", default=DEFAULTS["mid"])
    p.add_argument("--to", dest="c_to", default=DEFAULTS["to"])
    p.add_argument("--rx", type=float, default=16, help="corner radius of the background")
    p.add_argument("--grain", type=float, default=0.08, help="noise overlay opacity")
    p.add_argument("--angle", type=float, default=135, help="gradient angle in degrees")
    args = p.parse_args()

    src = args.svg.read_text()
    m = re.search(r"<svg[^>]*>", src)
    if not m or "termframe-bg" in src:
        sys.exit("not an un-backgrounded SVG (missing root tag or already processed)")

    rad = math.radians(args.angle % 360)
    dx, dy = math.cos(rad) / 2, math.sin(rad) / 2
    x1, y1 = 0.5 - dx, 0.5 - dy
    x2, y2 = 0.5 + dx, 0.5 + dy

    bg = f"""<defs id="termframe-bg">
<linearGradient id="tfbg-grad" x1="{x1:.3f}" y1="{y1:.3f}" x2="{x2:.3f}" y2="{y2:.3f}">
<stop offset="0" stop-color="{args.c_from}"/>
<stop offset="0.5" stop-color="{args.c_mid}"/>
<stop offset="1" stop-color="{args.c_to}"/>
</linearGradient>
<filter id="tfbg-grain" x="0" y="0" width="100%" height="100%">
<feTurbulence type="fractalNoise" baseFrequency="0.8" numOctaves="2" stitchTiles="stitch" result="n"/>
<feColorMatrix in="n" type="matrix" values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0.6 0.6 0.6 0 0"/>
<feComposite operator="in" in2="SourceGraphic"/>
</filter>
<clipPath id="tfbg-clip"><rect width="100%" height="100%" rx="{args.rx}"/></clipPath>
</defs>
<g clip-path="url(#tfbg-clip)">
<rect width="100%" height="100%" fill="url(#tfbg-grad)"/>
<rect width="100%" height="100%" filter="url(#tfbg-grain)" fill="#ffffff" opacity="{args.grain}"/>
</g>"""

    out = src[: m.end()] + "\n" + bg + src[m.end() :]
    (args.output or args.svg).write_text(out)


if __name__ == "__main__":
    main()
