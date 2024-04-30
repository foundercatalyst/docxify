module DocXify
  module Element
    class PageBreak < Base
      def to_s(_container = nil)
        <<~XML
          <w:p>
            <w:r>
              <w:br w:type="page"/>
            </w:r>
          </w:p>
        XML
      end
    end
  end
end
