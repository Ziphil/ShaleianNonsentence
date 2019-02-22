# coding: utf-8


SECTION_FIRST_PAGE_TOP_SPACE = "50mm"
SECTION_FIRST_HEADER_EXTENT = "35mm"
SECTION_CONTENT_SPACE = "1.8em"

converter.set("section.page-master") do |element|
  nodes = []
  nodes << Element.build("fo:simple-page-master") do |this|
    this["master-name"] = "section.first"
    this["page-width"] = PAGE_WIDTH
    this["page-height"] = PAGE_HEIGHT
    this["axf:bleed"] = BLEED_SIZE
    this["background-image"] = "url('../material/blank.svg')"
    this["background-repeat"] = "no-repeat"
    this << Element.build("fo:region-body") do |this|
      this["region-name"] = "section.body"
      this["margin-top"] = SECTION_FIRST_PAGE_TOP_SPACE
      this["margin-right"] = PAGE_INNER_SPACE
      this["margin-after"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_OUTER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "section.first-header"
      this["extent"] = SECTION_FIRST_HEADER_EXTENT
      this["precedence"] = "true"
    end
    this << Element.build("fo:region-after") do |this|
      this["region-name"] = "section.left-footer"
      this["extent"] = FOOTER_EXTENT
      this["precedence"] = "true"
    end
  end
  nodes << Element.build("fo:simple-page-master") do |this|
    this["master-name"] = "section.left"
    this["page-width"] = PAGE_WIDTH
    this["page-height"] = PAGE_HEIGHT
    this["axf:bleed"] = BLEED_SIZE
    this["background-image"] = "url('../material/blank.svg')"
    this["background-repeat"] = "no-repeat"
    this << Element.build("fo:region-body") do |this|
      this["region-name"] = "section.body"
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-right"] = PAGE_INNER_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_OUTER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "section.left-header"
      this["extent"] = HEADER_EXTENT
      this["precedence"] = "true"
    end
    this << Element.build("fo:region-after") do |this|
      this["region-name"] = "section.left-footer"
      this["extent"] = FOOTER_EXTENT
      this["precedence"] = "true"
    end
  end
  nodes << Element.build("fo:simple-page-master") do |this|
    this["master-name"] = "section.right"
    this["page-width"] = PAGE_WIDTH
    this["page-height"] = PAGE_HEIGHT
    this["axf:bleed"] = BLEED_SIZE
    this["background-image"] = "url('../material/blank.svg')"
    this["background-repeat"] = "no-repeat"
    this << Element.build("fo:region-body") do |this|
      this["region-name"] = "section.body"
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-right"] = PAGE_INNER_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_OUTER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "section.right-header"
      this["extent"] = HEADER_EXTENT
      this["precedence"] = "true"
    end
    this << Element.build("fo:region-after") do |this|
      this["region-name"] = "section.right-footer"
      this["extent"] = FOOTER_EXTENT
      this["precedence"] = "true"
    end
  end
  nodes << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "section"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "section.first"
        this["page-position"] = "first"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "section.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "section.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next nodes
end

converter.add(["section"], [""]) do |element|
  nodes = []
  nodes << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "section"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.first-header"
      this << call(element, "section.first-header")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-header"
      this << Element.new("fo:block")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-header"
      this << Element.new("fo:block")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-footer"
      this << Element.new("fo:block")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-footer"
      this << Element.new("fo:block")
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "section.body"
      this << Element.build("fo:block") do |this|
        this << apply(element, "section")
      end
    end
  end
  next nodes
end

converter.set("section.first-header") do |element|
  nodes = []
  number = element.each_xpath("preceding-sibling::section").to_a.size + 1
  nodes << Element.build("fo:block-container") do |this|
    this["id"] = "section.top-#{number}"
    this["height"] = "35mm + " + BLEED_SIZE
    this["margin-top"] = "-1 * " + BLEED_SIZE
    this["margin-left"] = "-1 * " + BLEED_SIZE
    this["margin-right"] = "-1 * " + BLEED_SIZE
    this["background-image"] = "url('../material/section_first_header.svg')"
    this["background-position-vertical"] = "-3mm + " + BLEED_SIZE
    this["background-position-horizontal"] = "-3mm + " + BLEED_SIZE
    this["background-repeat"] = "no-repeat"
    this << Element.build("fo:block-container") do |this|
      this["width"] = "30mm"
      this["top"] = "15mm + " + BLEED_SIZE
      this["left"] = "0mm + " + BLEED_SIZE
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "50pt"
      this["color"] = "white"
      this["letter-spacing"] = "-0.05em"
      this["text-align"] = "center"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this << ~number.to_s
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["top"] = "19mm + " + BLEED_SIZE
      this["left"] = "47mm + " + BLEED_SIZE
      this["font-size"] = "18pt"
      this["color"] = BORDER_COLOR
      this["letter-spacing"] = "0.05em"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this << apply(element.each_xpath("title").first, "section.first-header")
      end
    end
  end
  next nodes
end

converter.add(["wrong"], ["section"]) do |element|
  nodes = []
  nodes << Element.build("fo:block-container") do |this|
    this << Element.build("fo:block-container") do |this|
      this << Element.build("fo:block") do |this|
        this["top"] = "0mm"
        this["left"] = "0mm"
        this["padding-before"] = "1mm"
        this["padding-after"] = "1mm"
        this["padding-start"] = "3mm"
        this["padding-end"] = "3mm"
        this["color"] = "white"
        this["line-height"] = LINE_HEIGHT
        this["axf:border-radius"] = "2mm"
        this["background-color"] = BORDER_COLOR
        this["absolute-position"] = "absolute"
        this << apply(element, "section.wrong")
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["top"] = "-7.5mm"
      this["left"] = "-8mm"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this << Element.build("fo:external-graphic") do |this|
          this["src"] = "url('../material/wrong_badge.svg')"
        end
      end
    end
  end
  nodes << Element.build("fo:block") do |this|
    this["font-size"] = "0pt"
    this["text-align"] = "center"
    this << Element.build("fo:external-graphic") do |this|
      this["src"] = "url('../material/wrong_arrow.svg')"
    end
  end
  next nodes
end

converter.add(["correct"], ["section"]) do |element|
  nodes = []
  nodes << Element.build("fo:block-container") do |this|
    this << Element.build("fo:block") do |this|
      this["padding-before"] = "1mm"
      this["padding-after"] = "1mm"
      this["padding-start"] = "3mm"
      this["padding-end"] = "3mm"
      this["line-height"] = LINE_HEIGHT
      this["axf:border-radius"] = "2mm"
      this["background-color"] = BACKGROUND_COLOR
      this << apply(element, "section.correct")
    end
  end
  next nodes
end

converter.add(["sh"], ["section.wrong", "section.correct"]) do |element, scope|
  nodes = []
  nodes << Element.build("fo:block") do |this|
    this["font-size"] = "1.3em"
    this << apply(element, scope + ".sh")
  end
  next nodes
end

converter.add(["ja"], ["section.correct"]) do |element|
  nodes = []
  nodes << Element.build("fo:block") do |this|
    this << apply(element, "section.correct.ja")
  end
  next nodes
end

converter.add(["s"], ["section.wrong.sh", "section.correct.sh"]) do |element, scope|
  nodes = []
  nodes << Element.build("fo:inline") do |this|
    this["border-after-width"] = BORDER_WIDTH
    if scope.include?("wrong")
      this["border-after-color"] = "white"
    else
      this["border-after-color"] = "black"
    end
    this["border-after-style"] = "wave"
    this["axf:border-wave-form"] = "2mm " + BORDER_WIDTH
    this << apply(element, scope)
  end
end

converter.add(["content"], ["section"]) do |element|
  nodes = []
  nodes << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_CONTENT_SPACE
    this["space-before.maximum"] = SECTION_CONTENT_SPACE + " * " + MAXIMUM_RATIO
    this["space-before.minimum"] = SECTION_CONTENT_SPACE + " * " + MINIMUM_RATIO
    this["space-after"] = SECTION_CONTENT_SPACE
    this["space-after.maximum"] = SECTION_CONTENT_SPACE + " * " + MAXIMUM_RATIO
    this["space-after.minimum"] = SECTION_CONTENT_SPACE + " * " + MINIMUM_RATIO
    this << apply(element, "section.desc")
  end
  next nodes
end

converter.add(["p"], ["section.desc"]) do |element|
  nodes = []
  nodes << Element.build("fo:block") do |this|
    this["space-before"] = PARAGRAPH_SPACE
    this["space-before.maximum"] = PARAGRAPH_SPACE + " * " + MAXIMUM_RATIO
    this["space-before.minimum"] = PARAGRAPH_SPACE + " * " + MINIMUM_RATIO
    this["space-after"] = PARAGRAPH_SPACE
    this["space-after.maximum"] = PARAGRAPH_SPACE + " * " + MAXIMUM_RATIO
    this["space-after.minimum"] = PARAGRAPH_SPACE + " * " + MINIMUM_RATIO
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this << apply(element, "section.desc.p")
  end
  next nodes
end

converter.add(nil, ["section.desc.p"]) do |text|
  string = text.to_s
  string.gsub!(/(?<=。)\s*\n\s*/, "")
  next [~string]
end