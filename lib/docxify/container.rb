require "zip"

module DocXify
  class Container
    attr_accessor :document

    def initialize(document)
      @document = document
    end

    def render
      temp_file = Tempfile.new("docxify.zip")

      Zip::OutputStream.open(temp_file) do |zip|
        zip.put_next_entry "_rels/.rels"
        zip.write DocXify::Template.top_level_rels

        zip.put_next_entry "[Content_Types].xml"
        zip.write DocXify::Template.content_types

        zip.put_next_entry "word/theme/theme1.xml"
        zip.write DocXify::Template.theme

        zip.put_next_entry "word/fontTable.xml"
        zip.write DocXify::Template.font_table

        zip.put_next_entry "word/settings.xml"
        zip.write DocXify::Template.settings

        zip.put_next_entry "word/styles.xml"
        zip.write DocXify::Template.styles

        zip.put_next_entry "word/webSettings.xml"
        zip.write DocXify::Template.web_settings

        zip.put_next_entry "word/document.xml"
        zip.write document.build_xml(self)

        zip.put_next_entry "word/_rels/document.xml.rels"
        zip.write document_xml_rels

        @document.images.each do |image|
          zip.put_next_entry "word/media/#{image.filename}"
          zip.write image.data
        end
      end

      temp_file.flush
      temp_file.rewind
      temp_file.read
    ensure
      temp_file.close
      temp_file.unlink
    end

    def document_xml_rels
      xml = <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId3" Target="webSettings.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings"/>
          <Relationship Id="rId2" Target="settings.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings"/>
          <Relationship Id="rId1" Target="styles.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"/>
          <Relationship Id="rId5" Target="theme/theme1.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme"/>
          <Relationship Id="rId4" Target="fontTable.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable"/>
      XML

      @document.images.each do |image|
        xml << "<Relationship Id=\"#{image.reference}\" Target=\"media/#{image.filename}\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image\"/>"
      end

      xml << "</Relationships>"
      xml
    end
  end
end
