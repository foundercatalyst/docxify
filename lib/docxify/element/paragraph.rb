module DocXify
  module Element
    class Paragraph < Base
      attr_accessor :text, :font, :size, :color, :background, :align, :inline_styling, :tab_stops_cm, :hanging_cm

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
        @after = options[:after]
        @inline_styling = options.key?(:inline_styling) ? options[:inline_styling] : true
        @tab_stops_cm = options[:tab_stops_cm] || []
        @hanging_cm = options[:hanging_cm] || 0
      end

      def to_s(_container = nil)
        nodes = if @inline_styling
          parse_simple_html(@text)
        else
          [@text.gsub("<", "&lt;").gsub(">", "&gt;")]
        end

        xml = "<w:p>"

        xml << "<w:pPr>"
        xml << "<w:jc w:val=\"#{@align}\"/>" if @align != :left
        xml << "<w:spacing w:after=\"#{DocXify.pt2spacing @after}\"/>" if @after

        if tab_stops_cm.any?
          xml << "<w:tabs>"
          tab_stops_cm.each do |stop|
            xml << "<w:tab w:pos=\"#{DocXify.cm2dxa(stop)}\" w:val=\"left\"/>"
          end
          xml << "</w:tabs>"
        end

        if @hanging_cm&.positive?
          xml << "<w:ind w:hanging=\"#{DocXify.cm2dxa(@hanging_cm)}\" w:left=\"#{DocXify.cm2dxa(@hanging_cm)}\"/>"
        end

        xml << "</w:pPr>"

        nodes.each do |node|
          if node.is_a?(Hash) && node[:tag] == "a"
            xml << "<w:hyperlink r:id=\"#{ref_for_href(node[:attributes][:href])}\">"
          end

          xml << "<w:r>"
          xml << <<~XML
            <w:rPr>
              <w:rFonts w:ascii="#{@font}" w:cs="#{@font}" w:hAnsi="#{@font}"/>
              <w:color w:val="#{@color.gsub("#", "")}"/>
              <w:sz w:val="#{DocXify.pt2halfpt(@size)}"/>
              <w:szCs w:val="#{DocXify.pt2halfpt(@size)}"/>
              #{"<w:highlight w:val=\"yellow\"/>" if @highlight || (node.is_a?(Hash) && node[:tag].match?("mark"))}
              #{"<w:b/><w:bCs/>" if node.is_a?(Hash) && node[:tag].match?("b")}
              #{"<w:i/><w:iCs/>" if node.is_a?(Hash) && node[:tag].match?("i")}
              #{"<w:u w:val=\"single\"/>" if node.is_a?(Hash) && (node[:tag].match?("u") || node[:tag] == "a")}
              #{"<w:rStyle w:val=\"Hyperlink\"/>" if node.is_a?(Hash) && node[:tag] == "a"}
            </w:rPr>
          XML

          content = node.is_a?(Hash) ? node[:content] : node
          content = content.gsub("{CHECKBOX_EMPTY}", "☐").gsub("{CHECKBOX_CHECKED}", "☒")
          xml << "<w:t xml:space=\"preserve\">#{content}</w:t>"
          xml << "</w:r>"

          if node.is_a?(Hash) && node[:tag] == "a"
            xml << "</w:hyperlink>"
          end
        end

        xml << "</w:p>"
      end

      def ref_for_href(href)
        relation = nil

        @document.relationships.select { |r| r.is_a?(DocXify::Element::WebAddress) }.each do |r|
          if r.target == href
            relation = r
            break
          end
        end

        if relation.nil?
          relation = DocXify::Element::WebAddress.new(href)
          @document.relationships << relation
        end

        relation.reference
      end
    end
  end
end
