# Word PageLayouts are a weird concept; instead of a wrapping element or a
# "this applies to content from here on down", it's applied retrospectively
# to the content that came before it.
module DocXify
  module Element
    class PageLayout < Base
      attr_accessor :width, :height, :orientation

      def initialize(options = {})
        super()
        @document = options[:document]
        @margins = @document.margins
        @width = options[:width] || @document&.width || DocXify::A4_PORTRAIT_WIDTH
        @height = options[:height] || @document&.height || DocXify::A4_PORTRAIT_HEIGHT
        @orientation = options[:orientation] || :portrait
      end

      # Don't consider this part of the public API, they're used by Document if it's been created
      def bounds_width
        @width - @margins[:left] - @margins[:right]
      end

      def bounds_height
        @height - @margins[:top] - @margins[:bottom]
      end

      def to_s(_container = nil)
        <<~XML
          <w:p>
            <w:pPr>
              <w:sectPr>
                <w:pgSz w:w="#{@width}" w:h="#{@height}" w:orient="#{@orientation}"/>
                <w:pgMar w:bottom="#{DocXify.cm2dxa @margins[:bottom]}" w:footer="708" w:gutter="0" w:header="708" w:left="#{DocXify.cm2dxa @margins[:left]}" w:right="#{DocXify.cm2dxa @margins[:right]}" w:top="#{DocXify.cm2dxa @margins[:top]}"/>
                <w:cols w:space="708"/>
                <w:docGrid w:linePitch="360"/>
              </w:sectPr>
            </w:pPr>
          </w:p>
        XML
      end
    end
  end
end
