module DocXify
  module Element
    class Paragraph < Base
      attr_accessor :text, :font, :size, :color, :background, :align, :inline_styling, :tab_stops_cm

      def initialize(document, text, options = {})
        super(document)
        @text = text
        @font = options[:font] || document.font
        @size = options[:size] || document.size
        @color = options[:color] || document.color
        @background = options[:background] if options[:background]
        @background ||= document.background if document.background
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
        nodes.each do |node|
          xml << "<w:r><w:t xml:space=\"preserve\">#{node}</w:t></w:r>"
        end
        xml << "</w:p>"
      end
    end
  end
end
