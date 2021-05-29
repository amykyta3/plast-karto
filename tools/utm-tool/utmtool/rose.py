import math

from svgwrite import inch, mm
from svgwrite.container import Group
from svgwrite.shapes import Line, Circle
from svgwrite.text import Text

def square_rose(width_in = 2.5):
    major_tick_in = 0.13
    middle_tick_in = 0.1
    minor_tick_in = 0.07

    g = Group(stroke="black", stroke_width=0.4)

    for deg in range(360):
        rad = math.pi * deg/180

        stroke_width = 0.4
        if deg % 10 == 0:
            stroke_width = 0.6
            tick_len = major_tick_in
        elif deg % 45 == 0:
            tick_len = middle_tick_in*1.25
        elif deg % 5 == 0:
            tick_len = middle_tick_in
        else:
            tick_len = minor_tick_in

        if deg > 315 or deg <= 45:
            y1 = width_in/2
            x1 = math.tan(rad) * y1
            y2 = width_in/2 - tick_len
            x2 = math.tan(rad) * y2
        elif 45 < deg <= 135:
            x1 = width_in/2
            y1 = x1/math.tan(rad)
            x2 = width_in/2 - tick_len
            y2 = x2/math.tan(rad)
        elif 135 < deg <= 225:
            y1 = -width_in/2
            x1 = math.tan(rad) * y1
            y2 = -width_in/2 + tick_len
            x2 = math.tan(rad) * y2
        elif 225 < deg <= 315:
            x1 = -width_in/2
            y1 = x1/math.tan(rad)
            x2 = -width_in/2 + tick_len
            y2 = x2/math.tan(rad)

        # flip coordinates and center
        y1 = width_in/2 - y1
        y2 = width_in/2 - y2
        x1 += width_in/2
        x2 += width_in/2

        g.add(Line(
            (x1*inch, y1*inch),
            (x2*inch, y2*inch),
            stroke_width=stroke_width,
        ))

        if (deg % 10 == 0) or (deg % 45 == 0):
            if deg > 315 or deg < 45:
                rotate = 0
                xt = x2
                yt = y2 + 0.06
            elif deg == 45:
                rotate = 45
                xt = x2 - 0.04
                yt = y2 + 0.04
            elif 45 < deg < 135:
                rotate = 90
                xt = x2 - 0.06
                yt = y2
            elif deg == 135:
                rotate = -45
                xt = x2 - 0.02
                yt = y2 - 0.02
            elif 135 < deg < 225:
                rotate = 0
                xt = x2
                yt = y2 - 0.02
            elif deg == 225:
                rotate = 45
                xt = x2 + 0.02
                yt = y2 - 0.02
            elif 225 < deg < 315:
                rotate = -90
                xt = x2 + 0.06
                yt = y2
            elif deg == 315:
                rotate = -45
                xt = x2 + 0.04
                yt = y2 + 0.04

            t = Text(
                deg,
                (xt*inch, yt*inch),
                text_anchor="middle",
                font_size=1.5*mm,
            )
            t.rotate(
                rotate,
                (xt*72, yt*72)
            )

            g.add(t)

    # Center reticle
    g.add(Line(
        ((width_in/2)*inch, (width_in/2 - 0.1)*inch),
        ((width_in/2)*inch, (width_in/2 + 0.1)*inch),
    ))
    g.add(Line(
        ((width_in/2 - 0.1)*inch, (width_in/2)*inch),
        ((width_in/2 + 0.1)*inch, (width_in/2)*inch),
    ))
    g.add(Circle(
        ((width_in/2)*inch, (width_in/2)*inch), r=0.5*mm,
        fill="white"
    ))

    return g
