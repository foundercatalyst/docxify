module DocXify
  module Element
    class Divider < Base
      def to_s(_container = nil)
        <<~XML
          <w:p>
            <w:pPr>
              <w:pBdr>
                <w:bottom w:color="auto" w:space="1" w:sz="6" w:val="single"/>
              </w:pBdr>
            </w:pPr>
          </w:p>
          <w:p/>
        XML
      end
    end
  end
end
