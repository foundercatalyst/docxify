module DocXify
  class Document
    attr_accessor :font, :size, :color, :background
    attr_reader :content, :images

    def initialize(options = {})
      @content = []
      @images = []
      @width = options[:width] || A4_PORTRAIT_WIDTH
      @height = options[:height] || A4_PORTRAIT_HEIGHT
      @font = options[:font] || "Times New Roman"
      @size = options[:size] || 12
      @color = options[:color] || 12
      @background = options[:background] if options[:background]
      @margins = { top: 2, bottom: 2, left: 2, right: 2 }
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
        <w:document mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh wp14" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
          <w:body>
      XML

      @content.each do |element|
        xml << element.to_s(container)
      end

      xml << <<~XML
            <w:sectPr >
              <w:pgSz w:h="#{@height}" w:w="#{@width}"/>
              <w:pgMar w:bottom="#{DocXify.cm2dxa @margins[:bottom]}" w:footer="708" w:gutter="0" w:header="708" w:left="#{DocXify.cm2dxa @margins[:left]}" w:right="#{DocXify.cm2dxa @margins[:right]}" w:top="#{DocXify.cm2dxa @margins[:top]}"/>
              <w:cols w:space="708"/>
              <w:docGrid w:linePitch="360"/>
            </w:sectPr>
          </w:body>
        </w:document>
      XML
    end

    # MARK: Elements

    def add(element)
      @content << element
    end

    def add_image(file_path_or_data, options = {})
      file = DocXify::Element::File.new(self, file_path_or_data, options)
      @images << file
      add DocXify::Element::Image.new(self, file, options)
    end

    def add_numbered_list_item(text, level: 0)
      add DocXify::Element::NumberedListItem.new(self, text, level: level)
    end

    def add_page_break
      add DocXify::Element::PageBreak.new(self)
    end

    def add_divider
      add DocXify::Element::Divider.new(self)
    end

    def add_paragraph(text, options = {})
      add DocXify::Element::Paragraph.new(self, text, options)
    end

    def add_table(headers, rows, options = {})
      add DocXify::Element::Table.new(self, headers, rows, options)
    end

    # MARK: Private
  end
end
