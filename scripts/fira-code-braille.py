#!/usr/bin/env python3
"""Add circular Unicode Braille glyphs to Fira Code without flattening it."""

import math
import sys

from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont

BRAILLE_START = 0x2800
BRAILLE_END = 0x28FF
DOT_RADIUS_RATIO = 0.6
CIRCLE_SIDES = 16


def draw_circle(pen, center_x, center_y, radius):
    for point in range(CIRCLE_SIDES):
        angle = math.pi / 2 + point * 2 * math.pi / CIRCLE_SIDES
        coordinate = (
            round(center_x + math.cos(angle) * radius),
            round(center_y + math.sin(angle) * radius),
        )
        if point == 0:
            pen.moveTo(coordinate)
        else:
            pen.lineTo(coordinate)
    pen.closePath()


def dot_center(dot, width, top, bottom):
    # Unicode Braille bit order: 1, 2, 3, 7 / 4, 5, 6, 8.
    if dot < 6:
        row = dot % 3
        column = dot // 3
    else:
        row = 3
        column = dot - 6
    height = top - bottom
    return (
        width / 4 + column * width / 2,
        top - height / 8 - row * height / 4,
    )


def rename_font(font):
    for record in font["name"].names:
        value = record.toUnicode()
        replacement = value.replace("Fira Code", "Fira Code Braille").replace(
            "FiraCode", "FiraCodeBraille"
        )
        if replacement != value:
            font["name"].setName(
                replacement,
                record.nameID,
                record.platformID,
                record.platEncID,
                record.langID,
            )


def main(source, output):
    font = TTFont(source, recalcBBoxes=False, recalcTimestamp=False)
    glyph_order = font.getGlyphOrder()
    glyph_set = font.getGlyphSet()
    glyf = font["glyf"]
    hmtx = font["hmtx"].metrics
    width = hmtx[font.getBestCmap()[ord("M")]][0]
    hhea = font["hhea"]
    top = hhea.ascent + round(hhea.lineGap / 2)
    bottom = hhea.descent - round(hhea.lineGap / 2)
    radius = min(
        width / 4 * DOT_RADIUS_RATIO,
        (top - bottom) / 8 * DOT_RADIUS_RATIO,
    )

    for codepoint in range(BRAILLE_START, BRAILLE_END + 1):
        glyph_name = f"uni{codepoint:04X}"
        pen = TTGlyphPen(glyph_set)
        pattern = codepoint - BRAILLE_START
        for dot in range(8):
            if pattern & (1 << dot):
                draw_circle(pen, *dot_center(dot, width, top, bottom), radius)
        glyph = pen.glyph()
        glyph.recalcBounds(glyf)
        glyph_order.append(glyph_name)
        glyf.glyphs[glyph_name] = glyph
        hmtx[glyph_name] = (width, 0)
        font["gvar"].variations[glyph_name] = []
        for cmap in font["cmap"].tables:
            if cmap.isUnicode():
                cmap.cmap[codepoint] = glyph_name

    font.setGlyphOrder(glyph_order)
    font["maxp"].recalc(font)
    # Fira Code has no horizontal metric variation, so omitting this table is
    # equivalent and avoids an invalid implicit entry for each new glyph.
    del font["HVAR"]
    rename_font(font)
    font.save(output)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: fira-code-braille.py INPUT.ttf OUTPUT.ttf")
    main(sys.argv[1], sys.argv[2])
