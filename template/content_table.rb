# coding: utf-8


converter.set("content-table.page-master") do |element|
  this = Nodes[]
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
        this << call(element, "content-table.main")
      end
    end
  end
  next this
end

converter.set("content-table.main") do |element|
  this = Nodes[]
  this << ~"≡╹ω╹≡"
  next this
end