# coding: utf-8


require 'pp'
require 'fileutils'
require 'rexml/document'
include REXML

Kernel.load(File.dirname($0).encode("utf-8") + "/parser.rb")
Kernel.load(File.dirname($0).encode("utf-8") + "/utility.rb")
Encoding.default_external = "UTF-8"
$stdout.sync = true


class Converter

  attr_reader :configs

  def initialize(document)
    @document = document
    @configs = {}
    @templates = {}
    @functions = {}
    @default_element_template = lambda{|s| Nodes[]}
    @default_text_template = lambda{|s| Nodes[]}
  end

  def convert
    document = Document.new
    children = convert_element(@document.root, "")
    children.each do |child|
      document.add(child)
    end
    return document
  end

  def convert_element(element, scope, *args)
    nodes = nil
    @templates.each do |(element_pattern, scope_pattern), block|
      if element_pattern != nil && element_pattern.any?{|s| s === element.name} && scope_pattern.any?{|s| s === scope}
        nodes = block.call(element, scope, *args)
        break
      end
    end
    return nodes || @default_element_template.call(element)
  end

  def convert_text(text, scope, *args)
    nodes = nil
    @templates.each do |(element_pattern, scope_pattern), block|
      if element_pattern == nil && scope_pattern.any?{|s| s === scope}
        nodes = block.call(text, scope, *args)
        break
      end
    end
    return nodes || @default_text_template.call(text)
  end

  def apply(element, scope, *args)
    nodes = Nodes[]
    element.children.each do |child|
      case child
      when Element
        nodes << convert_element(child, scope, *args)
      when Text
        nodes << convert_text(child, scope, *args)
      end
    end
    return nodes
  end

  def call(element, name, *args)
    nodes = Nodes[]
    @functions.each do |function_name, block|
      if function_name == name
        nodes = block.call(element, *args)
        break
      end
    end
    return nodes
  end

  def add(element_pattern, scope_pattern, &block)
    @templates.store([element_pattern, scope_pattern], block)
  end

  def set(name, &block)
    @functions.store(name, block)
  end

  def add_default(element_pattern, &block)
    if element_pattern
      @default_element_template = block
    else
      @default_text_template = block
    end
  end

end


class WholeZiphilConverter

  OUTPUT_PATH = "../out/main.fo"
  MANUSCRIPT_DIR = "../manuscript"
  TEMPLATE_DIR = "../template"

  def save
    parser = create_parser
    converter = create_converter(parser.parse)
    formatter = create_formatter
    File.open(OUTPUT_PATH, "w") do |file|
      formatter.write(converter.convert, file)
    end
  end

  def create_parser(path = nil, main = true)
    source = File.read(path || MANUSCRIPT_DIR + "/main.zml")
    parser = ZenithalParser.new(source)
    parser.brace_name = "x"
    parser.bracket_name = "xn"
    parser.slash_name = "i"
    if main
      parser.register_macro("import") do |attributes, _|
        import_path = attributes["src"]
        import_parser = create_parser(MANUSCRIPT_DIR + "/" + import_path, false)
        document = import_parser.parse
        next [document.root]
      end
    end
    return parser
  end

  def create_converter(document)
    converter = Converter.new(document)
    Dir.each_child(TEMPLATE_DIR) do |entry|
      if entry =~ /\.rb/
        converter.instance_eval(File.read(TEMPLATE_DIR + "/" + entry), entry)
      end
    end
    return converter
  end

  def create_formatter
    formatter = Formatters::Default.new
    return formatter
  end

end


converter = WholeZiphilConverter.new
converter.save