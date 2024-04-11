module DocXify
  module Element
    class Base
      def initialize(document)
        @document = document
      end

      def to_s(container = nil)
        raise NotImplementedError
      end

      private

      def parse_simple_html(html)
        state = :text
        tag = ""
        content = ""
        result = []
        text = ""
        last_char = ""

        html.each_char do |char|
          # puts "State: #{state}, Char: #{char}, Tag: #{tag}, Content: #{content}, Text: #{text}"
          case state
          when :text # This is a text node, not part of an HTML tag
            if char == "<"
              state = :tag
              tag = ""
              result << text.strip unless text.strip.empty?
              text = ""
            else
              text << char
            end
          when :tag # Within an HTML tag itself
            if char == ">"
              state = :content
              content = ""
              tag_name, *attributes = tag.split
              tag_name.gsub!(/\s*\//, "")
              attributes.delete_if { |attr| attr == "/" }
              if attributes.any?
                attrs = {}
                attributes.each do |attribute|
                  name, value = attribute.split("=")
                  value = value.to_s[1..-2] if value
                  attrs[name.to_sym] = value
                end
                result << { tag: tag_name, attributes: attrs, content: "" }
              else
                result << { tag: tag_name, content: "" }
              end

              if last_char == "/"
                state = :text
              end
            elsif char == "/" && last_char == "<"
              state = :closing_tag
            else
              tag << char
            end
          when :closing_tag
            if char == ">"
              state = :text
            end
          when :content # With the content of an HTML tag
            if char == "<"
              state = :tag
              result.last[:content] = content.strip
              content = ""
            else
              content << char
            end
          end

          last_char = char
        end

        result << text.strip unless text.strip.empty?
        result
      end
    end
  end
end
