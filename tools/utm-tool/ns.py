#!/usr/bin/env python3

from svgwrite import inch, Drawing
from svgwrite.container import Group, Defs

from utmtool.rulers import corner_ruler
from utmtool.utils import write_to_pdf, UseInch, translate_inch
from utmtool.template import tool_template

#-------------------------------------------------------------------------------
# Build UTM Tool
#-------------------------------------------------------------------------------
tool_size = 2.48
utm_tool = Group(id='utm_tool', stroke="black", stroke_width=0.5)

utm_tool.add(
    tool_template("НС", tool_size)
)

# Large map ruler
scale = 1250
diag_shift = 0.40
r = corner_ruler(
    scale=scale,
    length=50,
    major_interval=10, minor_per_major=10
)
translate_inch(r, tool_size - diag_shift, diag_shift)
utm_tool.add(r)

# Small map ruler
scale = 4000
diag_shift = 0.85
r = corner_ruler(
    scale=scale,
    length=100,
    major_interval=20, minor_per_major=10
)
translate_inch(r, tool_size - diag_shift, diag_shift)
utm_tool.add(r)


#-------------------------------------------------------------------------------
# Repliacte onto printout
#-------------------------------------------------------------------------------
dwg = Drawing(size=(8.5*inch, 11*inch))

defs = Defs()
defs.add(utm_tool)
dwg.add(defs)

for xi in range(3):
    for yi in range(4):
        dwg.add(UseInch(
            utm_tool,
            (0.5 + xi*2.5, 0.5 + yi*2.5),
        ))
write_to_pdf(dwg, "UTM-roamer-ruler-NS.pdf")
