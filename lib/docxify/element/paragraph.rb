module DocXify
  module Element
    class Paragraph < Base
      attr_accessor :text, :font, :size, :color, :background, :align, :inline_styling, :tab_stops_cm

      def initialize(document, text, options = {})
        super()
        @document = document
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
        # TODO: Implement all optionality
        "<w:p><w:r><w:t xml:space=\"preserve\">#{@text}</w:t></w:r></w:p>"
      end
    end
  end
end
