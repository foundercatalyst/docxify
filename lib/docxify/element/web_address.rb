module DocXify
  module Element
    class WebAddress < Base
      attr_accessor :target

      def initialize(target)
        super()
        @target = target
      end

      def reference
        "url-#{Digest::SHA1.hexdigest(target)[0, 8]}"
      end

      def to_s
        "<Relationship Id=\"#{reference}\" Target=\"#{target}/\" TargetMode=\"External\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink\"/>"
      end
    end
  end
end
