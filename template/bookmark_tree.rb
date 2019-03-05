# coding: utf-8


converter.set("bookmark-tree") do |element|
  this = Nodes[]
  this << apply(element, "bookmark-tree.part")
  next this
end

converter.add(["part"], ["bookmark-tree.part"]) do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::part").to_a.size + 1
  title = element.each_xpath("title").first.inner_text
  this << Element.build("fo:bookmark") do |this|
    this["starting-state"] = "show"
    this << Element.build("fo:bookmark-title") do |this|
      this << ~title
    end
    this << apply_select(element, "following-sibling::section[count(preceding-sibling::part) = #{number}]", "bookmark-tree.section")
  end
end

converter.add(["section"], ["bookmark-tree.section"]) do |element|
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