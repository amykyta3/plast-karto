from lxml import etree
import xml.etree.ElementTree as ET

from svgwrite import Drawing
from svglib.svglib import SvgRenderer
from reportlab.graphics import renderPDF
from svgwrite.container import Use

#-------------------------------------------------------------------------------
def write_to_pdf(dwg: Drawing, path: str):
    svg_str = dwg.tostring()
    svg = ET.fromstring(svg_str, etree.XMLParser())
    svgRenderer = SvgRenderer(None)
    drawing = svgRenderer.render(svg)
    renderPDF.drawToFile(drawing, path)

#-------------------------------------------------------------------------------

def translate_mm(obj, x_mm, y_mm):
    def to_pt(mm):
        pt_per_inch = 72
        mm_per_inch = 25.4
        return pt_per_inch * (mm / mm_per_inch)

    obj.translate(to_pt(x_mm),to_pt(y_mm))

def translate_inch(obj, x_in, y_in):
    def to_pt(n):
        pt_per_inch = 72
        return pt_per_inch * n

    obj.translate(to_pt(x_in),to_pt(y_in))

#-------------------------------------------------------------------------------

def UseInch(obj, xy):
    def trans_inch(*n):
        pt_per_inch = 72
        return tuple([nn*pt_per_inch for nn in n])
    return Use(
        obj,
        trans_inch(*xy),
    )
