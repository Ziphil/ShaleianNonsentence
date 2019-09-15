# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Zenithal

Kernel.load(File.dirname($0).encode("utf-8") + "/utility.rb")
Encoding.default_external = "UTF-8"
$stdout.sync = true


class WholeBookConverter

  OUTPUT_PATH = "out/main.fo"
  MANUSCRIPT_DIR = "manuscript"
  TEMPLATE_DIR = "template"
  FORMATTER_COMMAND = "cd out & AHFCmd -pgbar -x 3 -d main.fo -p @PDF -o document.pdf 2> error.txt"

  def save
    parser = create_parser
    converter = create_converter(parser.parse)
    formatter = create_formatter
    File.open(OUTPUT_PATH, "w") do |file|
      formatter.write(converter.convert, file)
    end
    Open3.pipeline(FORMATTER_COMMAND)
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
    converter = ZenithalConverter.new(document)
    Dir.each_child(TEMPLATE_DIR) do |entry|
      if entry.end_with?(".rb")
        binding = TOPLEVEL_BINDING
        binding.local_variable_set(:converter, converter)
        Kernel.eval(File.read(TEMPLATE_DIR + "/" + entry), binding, entry)
      end
    end
    return converter
  end

  def create_formatter
    formatter = Formatters::Default.new
    return formatter
  end

end


whole_converter = WholeBookConverter.new
whole_converter.save