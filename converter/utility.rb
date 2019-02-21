# coding: utf-8


class Element

  def [](key)
    return attribute(key).to_s
  end

  def []=(key, value)
    add_attribute(key, value)
  end

  def each_xpath(*args, &block)
    if block
      XPath.each(self, *args) do |element|
        block.call(element)
      end
    else
      enumerator = Enumerator.new do |yielder|
        XPath.each(self, *args) do |element|
          yielder << element
        end
      end
      return enumerator
    end
  end

  def self.build(name, &block)
    element = Element.new(name)
    block.call(element)
    return element
  end

end


class Parent

  def <<(object)
    if object.is_a?(Array)
      object.each do |child|
        add(child)
      end
    else
      add(object)
    end
  end

end


class String

  def ~
    return Text.new(self, true, nil, true)
  end

end