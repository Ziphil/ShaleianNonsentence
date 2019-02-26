# coding: utf-8


converter.set("bookmark-tree") do |element|
  this = Nodes[]
  this << Element.build("fo:bookmark") do |this|
    this["starting-state"] = "show"
    this << Element.build("fo:bookmark-title") do |this|
      this << ~"非文集"
    end
    this << apply(element, "bookmark-tree.item")
  end
  next this
end

converter.add(["section"], ["bookmark-tree.item"]) do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::section").to_a.size + 1
  title = element.each_xpath("title").first.inner_text
  this << Element.build("fo:bookmark") do |this|
    this["internal-destination"] = "section.top-#{number}"
    this << Element.build("fo:bookmark-title") do |this|
      this << ~"#{number}. #{title}"
    end
  end
  next this
end