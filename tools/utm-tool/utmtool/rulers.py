from svgwrite import mm
from svgwrite.container import Group
from svgwrite.shapes import Line, Circle
from svgwrite.text import Text

#-------------------------------------------------------------------------------
def ruler(scale = 1000, length = 100, major_interval=10, minor_per_major=10, reverse=False, vertical=False):
    major_len_mm = 3
    mid_len_mm = 2
    minor_len_mm = 1
    font_size_mm = 2

    if reverse:
        sign = -1
    else:
        sign = 1

    g = Group()

    # Draw major lines
    mj = 0
    while mj < length:
        # Minor tick marks
        for i in range(1, minor_per_major):
            offset_mm = sign * ((mj+i*major_interval/minor_per_major)/scale)*1000
            if i == minor_per_major/2:
                # Half mark
                if vertical:
                    g.add(Line(
                        ((0)*mm, (offset_mm)*mm),
                        ((-mid_len_mm)*mm, (offset_mm)*mm)
                    ))
                else:
                    g.add(Line(
                        ((offset_mm)*mm, (0)*mm),
                        ((offset_mm)*mm, (mid_len_mm)*mm)
                    ))
            else:
                if vertical:
                    g.add(Line(
                        ((0)*mm, (offset_mm)*mm),
                        ((-minor_len_mm)*mm, (offset_mm)*mm)
                    ))
                else:
                    g.add(Line(
                        ((offset_mm)*mm, (0)*mm),
                        ((offset_mm)*mm, (minor_len_mm)*mm)
                    ))
        mj += major_interval

        if mj >= length:
            label = f"{mj}m"
        else:
            label = f"{mj}"

        # Major line
        offset_mm = sign * (mj/scale)*1000
        if vertical:
            g.add(Line(
                ((0)*mm, (offset_mm)*mm),
                ((-major_len_mm)*mm, (offset_mm)*mm)
            ))
            if offset_mm > (major_len_mm + font_size_mm*1.5):
                # only draw label if it wont collide w horizontal ruler
                g.add(Text(
                    label,
                    x=[(-major_len_mm - 1)*mm],
                    y=[(offset_mm + font_size_mm/2.5)*mm],
                    text_anchor="end",
                    font_size=font_size_mm*mm,
                ))
        else:
            g.add(Line(
                ((offset_mm)*mm, (0)*mm),
                ((offset_mm)*mm, (major_len_mm)*mm)
            ))
            g.add(Text(
                label,
                x=[(offset_mm)*mm],
                y=[(major_len_mm + font_size_mm)*mm],
                text_anchor="middle",
                font_size=font_size_mm*mm,
            ))

    return g

#-------------------------------------------------------------------------------
def corner_ruler(scale, length, major_interval, minor_per_major):
    g = Group(stroke="black", stroke_width=0.4)

    ruler_length_mm = (length/scale)*1000

    # Horizontal Ruler
    g.add(Line(
        (-ruler_length_mm*mm,0*mm),
        ((3)*mm, 0*mm)
    ))
    r = ruler(
        scale=scale,
        length=length,
        major_interval=major_interval, minor_per_major=minor_per_major,
        reverse=True, vertical=False
    )
    g.add(r)

    # Vertical Ruler
    g.add(Line(
        (0*mm,-3*mm),
        (0*mm, (ruler_length_mm)*mm)
    ))
    r = ruler(
        scale=scale,
        length=length,
        major_interval=major_interval, minor_per_major=minor_per_major,
        reverse=False, vertical=True
    )
    g.add(r)

    g.add(Circle(
        (0, 0), r=0.5*mm,
        fill="white"
    ))

    # Scale label
    g.add(Text(
        f"1:{scale}",
        x=[(-ruler_length_mm/2)*mm],
        y=[-1*mm],
        text_anchor="middle",
        font_size=2*mm,
        font_weight="bold",
    ))

    return g
