# coding: utf-8


converter.set("part.page-master") do |element|
  this = Nodes[]
  this << Element.build("fo:simple-page-master") do |this|
    this["master-name"] = "part.left"
    this["page-width"] = PAGE_WIDTH
    this["page-height"] = PAGE_HEIGHT
    this["axf:bleed"] = BLEED_SIZE
    if DEBUG
      this["background-image"] = "url('../material/blank.svg')"
      this["background-repeat"] = "no-repeat"
    end
    this << Element.build("fo:region-body") do |this|
      this["region-name"] = "part.dammy"
    end
    this << Element.build("fo:region-after") do |this|
      this["region-name"] = "part.left-footer"
      this["extent"] = FOOTER_EXTENT
      this["precedence"] = "true"
    end
  end
  this << Element.build("fo:simple-page-master") do |this|
    this["master-name"] = "part.right"
    this["page-width"] = PAGE_WIDTH
    this["page-height"] = PAGE_HEIGHT
    this["axf:bleed"] = BLEED_SIZE
    if DEBUG
      this["background-image"] = "url('../material/blank.svg')"
      this["background-repeat"] = "no-repeat"
    end
    this << Element.build("fo:region-body") do |this|
      this["region-name"] = "part.body"
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-right"] = PAGE_OUTER_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_INNER_SPACE
    end
    this << Element.build("fo:region-before") do |this|
      this["region-name"] = "part.right-header"
      this["extent"] = HEADER_EXTENT
      this["precedence"] = "true"
    end
    this << Element.build("fo:region-after") do |this|
      this["region-name"] = "part.right-footer"
      this["extent"] = FOOTER_EXTENT
      this["precedence"] = "true"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "part"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "part.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "part.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["part"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "part"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.right-header"
      this << call(element, "part.right-header")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "part.body"
      this << Element.build("fo:block") do |this|
        this << apply(element, "part")
      end
    end
  end
  next this
end

converter.set("part.right-header") do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::part").to_a.size + 1
  this << Element.build("fo:block-container") do |this|
    this["id"] = "part.top-#{number}"
  end
  next this
end

converter.add(["title"], ["part"]) do |element|
  this = Nodes[]
  number = element.parent.each_xpath("preceding-sibling::part").to_a.size + 1
  this << Element.build("fo:block") do |this|
    this["margin-top"] = "20mm"
    this["margin-bottom"] = "-7mm"
    this["font-family"] = SPECIAL_FONT_FAMILY
    this["font-size"] = "7em"
    this["color"] = BORDER_COLOR
    this["line-height"] = "1"
    this["text-align"] = "center"
    this << ~number.to_s
  end
  this << Element.build("fo:block-container") do |this|
    this["height"] = "30mm"
    this["margin-top"] = "-7mm"
    this["margin-left"] = "-1 * #{BLEED_SIZE} - #{PAGE_INNER_SPACE}"
    this["margin-right"] = "-1 * #{BLEED_SIZE} - #{PAGE_OUTER_SPACE}"
    this["padding-left"] = "#{BLEED_SIZE} + #{PAGE_INNER_SPACE}"
    this["padding-right"] = "#{BLEED_SIZE} + #{PAGE_OUTER_SPACE}"
    this["display-align"] = "center"
    this["background-color"] = BORDER_COLOR
    this << Element.build("fo:block") do |this|
      this["font-size"] = "4em"
      this["color"] = "white"
      this["text-align"] = "center"
      this["letter-spacing"] = "0.2em"
      this << apply(element, "part.title")
    end
  end
  next this
end

converter.add(["description"], ["part"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["margin-top"] = "8mm"
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this << apply(element, "part.description")
  end
  next this
end