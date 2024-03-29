# coding: utf-8


DEBUG = true

EUROPIAN_FONT_FAMILY = "Brill"
JAPANESE_FONT_FAMILY = "Yu Mincho"
EUROPIAN_SHALEIA_FONT_FAMILY = "Inter"
JAPANESE_SHALEIA_FONT_FAMILY = "Yu Gothic Medium"
SPECIAL_FONT_FAMILY = "Gill Sans Nova Cn Book"

FONT_SIZE = "9pt"
SHALEIA_FONT_SIZE = "100%"
LINE_HEIGHT = "1.6"

PAGE_WIDTH = "148mm"
PAGE_HEIGHT = "210mm"
PAGE_TOP_SPACE = "22mm"
PAGE_BOTTOM_SPACE = "22mm"
PAGE_INNER_SPACE = "23mm"
PAGE_OUTER_SPACE = "17mm"
HEADER_EXTENT = "12mm"
FOOTER_EXTENT = "12mm"
BLEED_SIZE = "0mm"

PARAGRAPH_SPACE = "0.4em"

MAXIMUM_RATIO = "1.4"
MINIMUM_RATIO = "0.8"
BORDERED_SPACE_RATIO = "1.5"

BORDER_WIDTH = "0.2mm"
BORDER_COLOR = "#444444"
BACKGROUND_COLOR = "#DDDDDD"

FONT_FAMILY = EUROPIAN_FONT_FAMILY + ", " + JAPANESE_FONT_FAMILY
SHALEIA_FONT_FAMILY = EUROPIAN_SHALEIA_FONT_FAMILY + ", " + JAPANESE_SHALEIA_FONT_FAMILY

converter.add(["root"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:root") do |this|
    this["xmlns:fo"] = "http://www.w3.org/1999/XSL/Format"
    this["xmlns:axf"] = "http://www.antennahouse.com/names/XSL/Extensions"
    this["xml:lang"] = "ja"
    this["font-family"] = FONT_FAMILY
    this["font-size"] = FONT_SIZE
    this["font-variant"] = "lining-nums"
    this["axf:ligature-mode"] = "all"
    this << Element.build("fo:layout-master-set") do |this|
      this << call(element, "section.page-master")
      this << call(element, "part.page-master")
      this << call(element, "content-table.page-master")
    end
    this << Element.build("fo:bookmark-tree") do |this|
      this << call(element, "bookmark-tree")
    end
    this << apply(element, "")
  end
  next this
end

converter.add(["x", "xn"], [//]) do |element, scope, *args|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["font-family"] = SHALEIA_FONT_FAMILY
    this["font-size"] = SHALEIA_FONT_SIZE
    this << apply(element, scope, *args)
  end
  next this
end

converter.add(["i"], [//]) do |element, scope, *args|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["font-style"] = "italic"
    this << apply(element, scope, *args)
  end
  next this
end

converter.add_default(nil) do |text|
  this = Nodes[]
  this << ~text.value
  next this
end