# coding: utf-8


CONTENT_TABLE_PART_SPACE = "6mm"
CONTENT_TABLE_SECTION_SPACE = "0.5mm"

converter.set("content-table.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "content-table.first"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "content-table.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "content-table.first-header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "content-table.left-footer"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "content-table.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "content-table.body"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "content-table.left-footer"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "content-table.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "content-table.body"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "content-table.right-footer"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "content-table"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "content-table.first"
        this["page-position"] = "first"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "content-table.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "content-table.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["content-table"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "content-table"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "content-table.first-header"
      this << call(element, "content-table.first-header")
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "content-table.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "content-table.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "content-table.body"
      this << Element.build("fo:block") do |this|
        this << apply_select(element, "/root/*", "content-table.part")
      end
    end
  end
  next this
end

converter.set("content-table.first-header") do |element|
  this = Nodes[]
  this << Element.build("fo:block-container") do |this|
    this["id"] = "content-table.top"
  end
  next this
end

converter.add(["part"], ["content-table.part"]) do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::part").to_a.size + 1
  title = element.each_xpath("title").first.inner_text
  this << Element.build("fo:block") do |this|
    this["space-before"] = CONTENT_TABLE_PART_SPACE
    this["space-after"] = CONTENT_TABLE_PART_SPACE
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this << Element.build("fo:block") do |this|
      this["border-bottom-width"] = "0.5mm"
      this["border-bottom-color"] = BORDER_COLOR
      this["border-bottom-style"] = "solid"
      this << Element.build("fo:inline-container") do |this|
        this["width"] = "6mm"
        this["margin-right"] = "0.6em"
        this["alignment-baseline"] = "central"
        this["relative-position"] = "relative"
        this["top"] = "0.2mm"
        this << Element.build("fo:block") do |this|
          this.reset_indent
          this["font-family"] = SPECIAL_FONT_FAMILY
          this["font-size"] = "3em"
          this["color"] = BORDER_COLOR
          this["line-height"] = "0"
          this["text-align-last"] = "center"
          this << ~number.to_s
        end
      end
      this << Element.build("fo:basic-link") do |this|
        this["internal-destination"] = "part.top-#{number}"
        this << Element.build("fo:inline") do |this|
          this["font-size"] = "1.2em"
          this["color"] = "black"
          this["line-height"] = "1"
          this["baseline-shift"] = "0.5mm"
          this << ~title
        end
      end
    end
    this << Element.build("fo:block") do |this|
      this["margin-right"] = "0mm"
      this["padding-before"] = "1mm"
      this["padding-after"] = "1mm"
      this["padding-right"] = "0.5mm"
      this["background-image"] = "url('../material/content_table_bar.svg')"
      this["background-repeat"] = "no-repeat"
      this["background-position-vertical"] = "bottom"
      this << apply_select(element, "following-sibling::section[count(preceding-sibling::part) = #{number}]", "content-table.section")
    end
  end
  next this
end

converter.add(["section"], ["content-table.section"]) do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::section").to_a.size + 1
  title = element.each_xpath("title").first.inner_text
  this << Element.build("fo:block") do |this|
    this["space-before"] = CONTENT_TABLE_SECTION_SPACE
    this["space-after"] = CONTENT_TABLE_SECTION_SPACE
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this["line-height"] = LINE_HEIGHT
    this["text-align-last"] = "justify"
    this << Element.build("fo:inline-container") do |this|
      this["width"] = "10mm"
      this["margin-right"] = "0.5em"
      this["alignment-baseline"] = "central"
      this["relative-position"] = "relative"
      this["top"] = "0.5mm"
      this << Element.build("fo:block") do |this|
        this.reset_indent
        this["font-family"] = SPECIAL_FONT_FAMILY
        this["font-size"] = "1.4em"
        this["color"] = "white"
        this["letter-spacing"] = "-0.05em"
        this["line-height"] = "0"
        this["text-align-last"] = "center"
        this << ~number.to_s
      end
    end
    this << Element.build("fo:basic-link") do |this|
      this["internal-destination"] = "section.top-#{number}"
      this << Element.build("fo:inline") do |this|
        this["line-height"] = LINE_HEIGHT
        this << apply(element.each_xpath("title").first, "section.first-header")
      end
    end
    this << Element.build("fo:leader") do |this|
      this["margin-left"] = "0.3em"
      this["margin-right"] = "0.3em"
      this["color"] = BORDER_COLOR
      this["leader-pattern"] = "rule"
      this["rule-style"] = "dotted"
      this["rule-thickness"] = "#{BORDER_WIDTH} * 2"
      this["baseline-shift"] = "0.3em"
    end
    this << Element.build("fo:inline-container") do |this|
      this["width"] = "4.5mm"
      this["alignment-baseline"] = "central"
      this << Element.build("fo:block") do |this|
        this["font-family"] = SPECIAL_FONT_FAMILY
        this["font-size"] = "1em"
        this["line-height"] = "1"
        this["text-align-last"] = "right"
        this << Element.build("fo:page-number-citation") do |this|
          this["ref-id"] = "section.top-#{number}"
        end
      end
    end
  end
  next this
end