module DocXify
  module Element
    class TableCell < Base
      attr_accessor :content, :valign, :align, :nowrap, :colspan, :width_cm, :borders, :font, :size, :colour

      def initialize(content, options = {})
        super()
        @content = content
        @valign = options[:valign] || :top
        @align = options[:align] || :left
        @nowrap = options[:nowrap]
        @colspan = options[:colspan]
        @rowspan = options[:rowspan]
        @width_cm = options[:width_cm]
        @font = options[:font]
        @size = options[:size]
        @color = options[:color]
        @borders = options[:borders]&.map(&:to_sym) || []
      end

      def to_s
        xml = "<w:tc>"
        xml << "<w:tcPr>"
        xml << %Q(<w:tcW w:type="dxa" w:w="#{DocXify.cm2dxa(@width_cm)}"/>)
        if !@colspan.nil? && @colspan.to_i > 1
          xml << %Q(<w:gridSpan w:val="#{@colspan}"/>')
        end

        if borders.any?
          xml << "<w:tcBorders>"
          xml << (borders.include?(:top) ? '<w:top w:color="auto" w:space="0" w:sz="4" w:val="single"/>' : '<w:top w:val="nil"/>')
          xml << (borders.include?(:bottom) ? '<w:bottom w:color="auto" w:space="0" w:sz="4" w:val="single"/>' : '<w:bottom w:val="nil"/>')
          xml << (borders.include?(:left) ? '<w:left w:color="auto" w:space="0" w:sz="4" w:val="single"/>' : '<w:left w:val="nil"/>')
          xml << (borders.include?(:right) ? '<w:right w:color="auto" w:space="0" w:sz="4" w:val="single"/>' : '<w:right w:val="nil"/>')
          xml << "</w:tcBorders>"
        end

        if @valign != :top
          xml << %Q(<w:vAlign w:val="#{@valign}"/>)
        end

        if @nowrap
          xml << "<w:noWrap/>"
        end

        if @content.nil?
          @content = "" # Nil is useful for rowspan, but we need to output something or Word breaks
        end

        if @rowspan
          xml << '<w:vMerge w:val="restart"/>'
        elsif @content == ""
          xml << "<w:vMerge/>"
        end

        xml << "</w:tcPr>"

        xml << DocXify::Element::Paragraph.new(@content, document: @document, font: @font, size: @size, color: @color, align: @align).to_s

        xml << "</w:tc>"

        xml
      end
    end
  end
end
