# coding: utf-8


class Element

  def self.build_page_master(&block)
    this = Nodes[]
    this << Element.build("fo:simple-page-master") do |this|
      this["page-width"] = PAGE_WIDTH
      this["page-height"] = PAGE_HEIGHT
      this["axf:bleed"] = BLEED_SIZE
      if DEBUG
        this["background-image"] = "url('../material/blank.svg')"
        this["background-repeat"] = "no-repeat"
      end
      block&.call(this)
    end
    return this
  end

  def self.build_region_body(position, &block)
    this = Nodes[]
    this << Element.build("fo:region-body") do |this|
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = (position == :left) ? PAGE_OUTER_SPACE : PAGE_INNER_SPACE
      this["margin-right"] = (position == :left) ? PAGE_INNER_SPACE : PAGE_OUTER_SPACE
      block&.call(this)
    end
    return this
  end

end