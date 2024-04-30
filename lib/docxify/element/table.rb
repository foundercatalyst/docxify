# Structure of a table element looks something like this
# <w:tbl> - Table element
#   <w:tblPr> - Table properties
#   <w:tblGrid> - Table grid (column widths)
#   <w:tr> - Table row
#     <w:tc> - Table cell
#       <w:tcPr> - Table cell properties
#        <w:tcW w:type="dxa" w:w="1502"/> - Table cell width
#        <w:vMerge w:val="restart"/> - Something about merging TODO - figure out
#        <w:tcBorders> - Overriding table cell borders
#          <w:top w:val="nil"/>
#          <w:bottom w:color="auto" w:space="0" w:sz="4" w:val="single"/>
#          <w:right w:val="nil"/>
#        </w:tcBorders>
#        <w:vAlign w:val="bottom"/>
#      </w:tcPr>
#      <w:p> - Paragraph element

module DocXify
  module Element
    class Table < Base
      attr_accessor :rows, :column_widths

      def initialize(rows, options = {})
        super()
        @document = options[:document]
        @rows = rows
      end

      def to_s(_container = nil)
        xml = ""
        xml << table_element_start
        xml << table_properties
        xml << table_grid
        @rows.each do |row|
          xml << table_row(row)
        end
        xml << table_element_end
        xml
      end

      def table_element_start
        "<w:tbl>"
      end

      def table_properties
        xml = ""
        xml << "<w:tblPr>"
        xml << '<w:tblStyle w:val="TableGrid"/>'
        xml << '<w:tblW w:type="auto" w:w="0"/>'
        xml << "<w:tblBorders>"
        xml << '<w:top w:color="auto" w:space="0" w:sz="0" w:val="none"/>'
        xml << '<w:left w:color="auto" w:space="0" w:sz="0" w:val="none"/>'
        xml << '<w:bottom w:color="auto" w:space="0" w:sz="0" w:val="none"/>'
        xml << '<w:right w:color="auto" w:space="0" w:sz="0" w:val="none"/>'
        xml << "</w:tblBorders>"
        xml << '<w:tblLook w:firstColumn="1" w:firstRow="1" w:lastColumn="0" w:lastRow="0" w:noHBand="0" w:noVBand="1" w:val="04A0"/>'
        xml << "</w:tblPr>"
        xml
      end

      def table_grid
        default_equal_width = (@document.width / @rows.first.size).to_i

        @column_widths = []
        xml = "<w:tblGrid>"
        @rows.first.each do |cell|
          width = if cell.width_cm
            DocXify.cm2dxa(cell.width_cm)
          else
            default_equal_width
          end
          xml << "<w:gridCol w:w=\"#{width}\"/>"
          @column_widths << width
        end

        xml << "</w:tblGrid>"
        xml
      end

      def table_row(row)
        xml = "<w:tr>"
        widths = @column_widths.dup
        row.each do |cell|
          if cell.nil?
            cell = DocXify::Element::TableCell.new(nil)
          end

          if cell.width_cm.nil?
            cell.width_cm = 0
            (cell.colspan || 1).times do
              cell.width_cm += DocXify.dxa2cm(widths.shift)
            end
          end

          xml << cell.to_s
        end
        xml << "</w:tr>"
        xml
      end

      def table_element_end
        "</w:tbl>"
      end
    end
  end
end
