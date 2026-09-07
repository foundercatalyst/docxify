require "tempfile"
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
        write_entry zip, "_rels/.rels", DocXify::Template.top_level_rels
        write_entry zip, "[Content_Types].xml", DocXify::Template.content_types
        write_entry zip, "word/theme/theme1.xml", DocXify::Template.theme
        write_entry zip, "word/fontTable.xml", DocXify::Template.font_table
        write_entry zip, "word/settings.xml", DocXify::Template.settings
        write_entry zip, "word/styles.xml", DocXify::Template.styles
        write_entry zip, "word/webSettings.xml", DocXify::Template.web_settings
        write_entry zip, "word/document.xml", document.build_xml(self)
        write_entry zip, "word/_rels/document.xml.rels", document_xml_rels

        @document.relationships.each do |relation|
          if relation.is_a?(DocXify::Element::File)
            write_entry zip, "word/media/#{relation.filename}", relation.data
          end
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
      xml = +<<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId3" Target="webSettings.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings"/>
          <Relationship Id="rId2" Target="settings.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings"/>
          <Relationship Id="rId1" Target="styles.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"/>
          <Relationship Id="rId5" Target="theme/theme1.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme"/>
          <Relationship Id="rId4" Target="fontTable.xml" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable"/>
      XML

      @document.relationships.each do |relation|
        xml << relation.to_s
      end

      xml << "</Relationships>"
      xml
    end

    private

    # Word and other OPC readers reject Zip64 headers. Since rubyzip 3 defaults
    # to Zip64 for any entry whose size is unknown while its local header is
    # streamed out, declare the size up front (all entry data is already in
    # memory) so entries stay in the classic zip format.
    def write_entry(zip, name, data)
      zip.put_next_entry Zip::Entry.new(nil, name, size: data.bytesize)
      zip.write data
    end
  end
end
