module DocXify
  class Document
    attr_accessor :font, :size, :color, :background, :margins, :page_layout
    attr_reader :content, :relationships, :width

    def initialize(options = {})
      @content = []
      @relationships = []
      @width = options[:width] || A4_PORTRAIT_WIDTH
      @height = options[:height] || A4_PORTRAIT_HEIGHT
      @orientation = options[:orientation] || :portrait
      @font = options[:font] || "Times New Roman"
      @size = options[:size] || 12
      @color = options[:color] || 12
      @background = options[:background] if options[:background]
      @margins = { top: 2, bottom: 2, left: 2, right: 2 }.merge(options[:margins] || {})
    end

    def default_styling(options = {})
      @font = options[:font] if options[:font]
      @size = options[:size] if options[:size]
      @color = options[:color] if options[:color]
      @background = options[:background] if options[:background]
    end

    # MARK: Rendering

    def render(path = nil)
      container = DocXify::Container.new(self)

      if path
        File.write(path, container.render)
      else
        container.render
      end
    end

    def build_xml(container)
      xml = <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <w:document mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh wp14" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
          <w:body>
      XML

      # See the note in DocXify::Element::PageLayout for why it's not just handled the same as any other element
      @page_layout = DocXify::Element::PageLayout.new(width: @width, height: @height, orientation: @orientatation, document: self)

      @content.each do |element|
        if element.is_a?(DocXify::Element::PageLayout)
          xml << @page_layout.to_s
          @page_layout = element
        else
          xml << element.to_s(container)
        end
      end

      xml << @page_layout.to_s

      xml << <<~XML
          </w:body>
        </w:document>
      XML
    end

    # MARK: Elements

    def add(element)
      @content << element
    end

    def add_image(file_path_or_data, options = {})
      file = if file_path_or_data.is_a?(DocXify::Element::File)
        file_path_or_data
      else
        add_file(file_path_or_data)
      end
      add DocXify::Element::Image.new(file, options)
    end

    def add_file(file_path_or_data)
      file = DocXify::Element::File.new(file_path_or_data)
      @relationships << file
      file
    end

    def add_page_break
      add DocXify::Element::PageBreak.new
    end

    def add_page_layout(options = {})
      options[:document] = self
      add DocXify::Element::PageLayout.new(options)
    end

    def add_divider
      add DocXify::Element::Divider.new
    end

    def add_paragraph(text, options = {})
      options[:document] = self
      add DocXify::Element::Paragraph.new(text, options)
    end

    def add_table(rows, options = {})
      options[:document] = self
      add DocXify::Element::Table.new(rows, options)
    end
  end
end
