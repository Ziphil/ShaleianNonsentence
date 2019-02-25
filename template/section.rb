# coding: utf-8


SECTION_FIRST_PAGE_TOP_SPACE = "50mm"
SECTION_FIRST_HEADER_EXTENT = "35mm"
SECTION_PAGE_TOP_SPACE = "23mm"
SECTION_HEADER_EXTENT = "13mm"
SECTION_CONTENT_SPACE = "2em"
SECTION_SEPARATOR_SPACE = "1em"

converter.set("section.page-master") do |element|
  nodes = Nodes[]
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
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
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
      this["margin-top"] = SECTION_PAGE_TOP_SPACE
      this["margin-right"] = PAGE_INNER_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_OUTER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "section.right-header"
      this["extent"] = SECTION_HEADER_EXTENT
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
      this["margin-top"] = SECTION_PAGE_TOP_SPACE
      this["margin-right"] = PAGE_OUTER_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_INNER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "section.right-header"
      this["extent"] = SECTION_HEADER_EXTENT
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
  nodes = Nodes[]
  nodes << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "section"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.first-header"
      this << call(element, "section.first-header")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-header"
      this << call(element, "section.right-header")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "section.body"
      this << Element.build("fo:marker") do |this|
        this["marker-class-name"] = "section"
        this << apply(element.each_xpath("title").first, "section.first-header")
      end
      this << Element.build("fo:block") do |this|
        this << apply(element, "section")
      end
    end
  end
  next nodes
end

converter.set("section.first-header") do |element|
  nodes = Nodes[]
  number = element.each_xpath("preceding-sibling::section").to_a.size + 1
  link_ids = element.attribute("rel").to_s.split(/\s*,\s*/)
  link_numbers = link_ids.map{|s| element.parent.elements.find_index{|t| t.name == "section" && t.attribute("id").to_s == s} + 1}
  link_numbers.sort!
  nodes << Element.build("fo:block-container") do |this|
    this["id"] = "section.top-#{number}"
    this["height"] = "#{SECTION_FIRST_HEADER_EXTENT} + #{BLEED_SIZE}"
    this["margin-top"] = "-1 * #{BLEED_SIZE}"
    this["margin-left"] = "-1 * #{BLEED_SIZE}"
    this["margin-right"] = "-1 * #{BLEED_SIZE}"
    this["background-image"] = "url('../material/section_first_header.svg')"
    this["background-position-vertical"] = "-3mm + #{BLEED_SIZE}"
    this["background-position-horizontal"] = "-3mm + #{BLEED_SIZE}"
    this["background-repeat"] = "no-repeat"
    this << Element.build("fo:block-container") do |this|
      this["width"] = "30mm"
      this["top"] = "20mm + #{BLEED_SIZE}"
      this["left"] = "0mm + #{BLEED_SIZE}"
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "35pt"
      this["color"] = "white"
      this["letter-spacing"] = "-0.05em"
      this["text-align"] = "center"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        if element.attribute("id").to_s == "layout-test"
          this << ~"346"
        else
          this << ~number.to_s
        end
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["width"] = "85mm"
      this["block-progression-dimension"] = "0mm"
      this["block-progression-dimension.maximum"] = "100%"
      this["bottom"] = "8mm"
      this["left"] = "43mm + #{BLEED_SIZE}"
      this["font-size"] = "16pt"
      this["line-height"] = "1.1"
      this["text-align"] = "justify"
      this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
      this["axf:avoid-widow-words"] = "true"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this << apply(element.each_xpath("title").first, "section.first-header")
      end
    end
    unless link_numbers.empty?
      this << Element.build("fo:block-container") do |this|
        this["top"] = "30.5mm + #{BLEED_SIZE}"
        this["left"] = "43mm + #{BLEED_SIZE}"
        this["absolute-position"] = "absolute"
        this << Element.build("fo:block") do |this|
          this["font-size"] = "0.8em"
          this << Element.build("fo:inline") do |this|
            this["margin-right"] = "0.7em"
            this << ~"関連項目:"
          end
          link_numbers.each_with_index do |link_number, i|
            unless i == 0
              this << Element.build("fo:inline") do |this|
                this["margin-left"] = "0.1em"
                this["margin-right"] = "0.5em"
                this << ~","
              end
            end
            this << Element.build("fo:basic-link") do |this|
              this["internal-destination"] = "section.top-#{link_number}"
              this << Element.build("fo:inline") do |this|
                this["font-family"] = SPECIAL_FONT_FAMILY
                this["font-size"] = "1.5em"
                this["letter-spacing"] = "-0.05em"
                this << ~link_number.to_s
              end
            end
          end
        end
      end
    end
  end
  next nodes
end

converter.set("section.right-header") do |element|
  nodes = Nodes[]
  nodes << Element.build("fo:block-container") do |this|
    this["height"] = "#{SECTION_HEADER_EXTENT} + #{BLEED_SIZE}"
    this["margin-top"] = "-1 * #{BLEED_SIZE}"
    this["margin-left"] = "-1 * #{BLEED_SIZE}"
    this["margin-right"] = "-1 * #{BLEED_SIZE}"
    this["background-image"] = "url('../material/section_header.svg')"
    this["background-position-vertical"] = "-3mm + #{BLEED_SIZE}"
    this["background-position-horizontal"] = "-3mm + #{BLEED_SIZE}"
    this["background-repeat"] = "no-repeat"
  end
  next nodes
end

converter.add(["head"], ["section"]) do |element|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this << apply(element, "section.head")
  end
  next nodes
end

converter.add(["wrong"], ["section.head"]) do |element|
  nodes = Nodes[]
  nodes << Element.build("fo:block-container") do |this|
    this << Element.build("fo:block-container") do |this|
      this << Element.build("fo:block") do |this|
        this["top"] = "0mm"
        this["left"] = "0mm"
        this["margin-left"] = "-2mm"
        this["margin-right"] = "-2mm"
        this["padding-before"] = "1mm"
        this["padding-after"] = "1mm"
        this["padding-left"] = "3mm"
        this["padding-right"] = "3mm"
        this["color"] = "white"
        this["line-height"] = LINE_HEIGHT
        this["axf:border-radius"] = "2mm"
        this["background-color"] = BORDER_COLOR
        this["absolute-position"] = "absolute"
        this << apply(element, "section.head.wrong")
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["top"] = "-7.5mm"
      this["left"] = "-7mm"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this << Element.build("fo:external-graphic") do |this|
          this["src"] = "url('../material/wrong_badge.svg')"
        end
      end
    end
  end
  nodes << Element.build("fo:block") do |this|
    this["space-after"] = "0.5mm"
    this["font-size"] = "0pt"
    this["text-align"] = "center"
    this << Element.build("fo:external-graphic") do |this|
      this["src"] = "url('../material/wrong_arrow.svg')"
    end
  end
  next nodes
end

converter.add(["correct", "wrong"], [/section\.(head|content)/]) do |element, scope|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    if scope.include?("content")
      this["space-before"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO}"
      this["space-before.maximum"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO} * #{MAXIMUM_RATIO}"
      this["space-before.minimum"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO} * #{MINIMUM_RATIO}"
      this["space-after"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO}"
      this["space-after.maximum"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO} * #{MAXIMUM_RATIO}"
      this["space-after.minimum"] = "#{PARAGRAPH_SPACE} * #{BORDERED_SPACE_RATIO} * #{MINIMUM_RATIO}"
    end
    this["margin-left"] = "-2mm"
    this["margin-right"] = "-2mm"
    this["padding-before"] = "1mm"
    this["padding-after"] = "1mm"
    this["padding-left"] = "3mm"
    this["padding-right"] = "3mm"
    this["line-height"] = LINE_HEIGHT
    this["axf:border-radius"] = "2mm"
    if element.name.include?("wrong")
      this["color"] = "white"
      this["background-color"] = BORDER_COLOR
    else
      this["background-color"] = BACKGROUND_COLOR
    end
    this << apply(element, scope + "." + element.name)
  end
  next nodes
end

converter.add(["li"], [/section\.(head|content)\.(wrong|correct)/]) do |element, scope|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this << apply(element, scope + ".li")
  end
  next nodes
end

converter.add(["sh"], [/section\.(head|content)\.(wrong|correct)\.li/]) do |element, scope|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this["font-size"] = "1.2em"
    this << Element.build("fo:external-graphic") do |this|
      this["margin-right"] = "0.4em"
      if scope.include?("wrong")
        this["src"] = "url('../material/wrong_mark.svg')"
      else
        this["src"] = "url('../material/correct_mark.svg')"
      end
    end
    this << apply(element, scope + ".sh")
  end
  next nodes
end

converter.add(["ja"], [/section\.(head|content)\.(wrong|correct)\.li/]) do |element, scope|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this["margin-left"] = "0.8em"
    this["keep-with-previous.within-page"] = "always"
    this["keep-with-previous.within-column"] = "always"
    this << Element.build("fo:external-graphic") do |this|
      this["margin-right"] = "0.4em"
      this["baseline-shift"] = "0.1em"
      this["src"] = "url('../material/translation_arrow.svg')"
    end
    this << apply(element, scope + ".ja")
  end
  next nodes
end

converter.add(["s"], [/section\.(head|content)\.(wrong|correct)\.li\.sh/]) do |element, scope|
  nodes = Nodes[]
  nodes << Element.build("fo:inline") do |this|
    this["padding-bottom"] = "0.05em"
    this["border-bottom-width"] = BORDER_WIDTH
    if scope.include?("wrong")
      this["border-bottom-color"] = "white"
    else
      this["border-bottom-color"] = "black"
    end
    this["border-bottom-style"] = "wave"
    this["axf:border-wave-form"] = "1.5mm #{BORDER_WIDTH}"
    this << apply(element, scope)
  end
end

converter.add(["content"], ["section"]) do |element|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_CONTENT_SPACE
    this["space-after"] = SECTION_SEPARATOR_SPACE
    this["margin-left"] = "-3mm"
    this["margin-right"] = "-3mm"
    this << Element.build("fo:external-graphic") do |this|
      this["src"] = "url('../material/content_separator.svg')"
    end
  end
  nodes << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_SEPARATOR_SPACE
    this << apply(element, "section.content")
  end
  next nodes
end

converter.add(["p"], ["section.content"]) do |element|
  nodes = Nodes[]
  nodes << Element.build("fo:block") do |this|
    this["space-before"] = PARAGRAPH_SPACE
    this["space-before.maximum"] = "#{PARAGRAPH_SPACE} * #{MAXIMUM_RATIO}"
    this["space-before.minimum"] = "#{PARAGRAPH_SPACE} * #{MINIMUM_RATIO}"
    this["space-after"] = PARAGRAPH_SPACE
    this["space-after.maximum"] = "#{PARAGRAPH_SPACE} * #{MAXIMUM_RATIO}"
    this["space-after.minimum"] = "#{PARAGRAPH_SPACE} * #{MINIMUM_RATIO}"
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this["widows"] = "1"
    this["orphans"] = "1"
    this << apply(element, "section.content.p")
  end
  next nodes
end

converter.add(nil, ["section.content.p"]) do |text|
  nodes = Nodes[]
  nodes << ~text.to_s.gsub(/(?<=。)\s*\n\s*/, "")
  next nodes
end