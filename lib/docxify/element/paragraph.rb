module DocXify
  module Element
    class Paragraph < Base
      attr_accessor :text, :font, :size, :color, :background, :align, :inline_styling, :tab_stops_cm

      def initialize(text, options = {})
        super()
        @document = options[:document]
        @text = text
        @font = options[:font] || @document&.font || "Times New Roman"
        @size = options[:size] || @document&.size || 14
        @color = options[:color] || @document&.color || "#000000"
        @highlight = options[:highlight] || false
        @background = options[:background] if options[:background]
        @background ||= @document&.background if @document&.background
        @align = options[:align] || :left
        @inline_styling = options[:inline_styling] || true
        @tab_stops_cm = options[:tab_stops_cm] || []
      end

      def to_s(_container = nil)
        nodes = if @inline_styling
          parse_simple_html(@text)
        else
          [@text]
        end

        xml = "<w:p>"
        xml << <<~XML
          <w:pPr>
            <w:jc w:val="#{@align}"/>
          </w:pPr>
        XML
        xml << "<w:r>"
        xml << <<~XML
          <w:rPr>
            <w:rFonts w:ascii="#{@font}" w:cs="#{@font}" w:hAnsi="#{@font}"/>
            <w:color w:val="#{@color.gsub("#", "")}"/>
            <w:sz w:val="#{DocXify.pt2halfpt(@size)}"/>
            <w:szCs w:val="#{DocXify.pt2halfpt(@size)}"/>
            #{"<w:highlight w:val=\"yellow\"/>" if @highlight}
          </w:rPr>
        XML

        nodes.each do |node|
          xml << "<w:t xml:space=\"preserve\">#{node}</w:t>"
        end
        xml << "</w:r></w:p>"
      end
    end
  end
end
