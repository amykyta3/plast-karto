from svgwrite import mm, inch
from svgwrite.container import Group
from svgwrite.shapes import Circle, Rect
from svgwrite.text import Text

from .rose import square_rose

def tool_template(name, width_in):
    g = Group(
        stroke="black",
        stroke_width=0.5,
        font_family="Arial, Helvetica",
    )

    # Border
    g.add(Rect(
        (0,0),
        (width_in*inch, width_in*inch),
        fill="none",
    ))

    # Lanyard punch
    g.add(Circle(
        (0.4*inch, (width_in-0.4)*inch),
        3.5*mm,
        fill="none",
    ))

    # plast-karto!
    g.add(Text(
        "https://plast-karto.readthedocs.io",
        ((width_in/2)*inch, (width_in-0.3)*inch),
        text_anchor="middle",
        font_size=2*mm,
    ))

    g.add(Text(
        name,
        ((0.75)*inch, (width_in-0.75)*inch),
        text_anchor="middle",
        font_size=4*mm,
    ))

    g.add(square_rose(width_in))
    return g
