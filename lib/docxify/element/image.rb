module DocXify
  module Element
    class Image < Base
      attr_accessor :file, :align, :height_cm, :width_cm

      def initialize(file, options = {})
        super()
        @file = file

        @align = options[:align] || :left
        @height_cm = options[:height_cm] || 5
        @width_cm = options[:width_cm] || 5
      end

      def id
        rand(1_000_000_000)
      end

      def to_s(_container = nil)
        xml = "<w:p>"

        if @align == :right
          xml << <<~XML
            <w:pPr>
              <w:jc w:val="right"/>
            </w:pPr>
          XML
        elsif @align == :center
          xml << <<~XML
            <w:pPr>
              <w:jc w:val="center"/>
            </w:pPr>
          XML
        end

        xml << <<~XML
            <w:r>
              <w:rPr>
                <w:noProof/>
              </w:rPr>
              <w:drawing>
                <wp:inline distB="0" distL="0" distR="0" distT="0">
                  <wp:extent cx="#{DocXify.cm2emu(@width_cm)}" cy="#{DocXify.cm2emu(@height_cm)}"/>
                  <wp:effectExtent b="0" l="0" r="0" t="0"/>
                  <wp:docPr id="#{id}" name="Picture 1"/>
                  <wp:cNvGraphicFramePr>
                    <a:graphicFrameLocks noChangeAspect="1" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"/>
                  </wp:cNvGraphicFramePr>
                  <a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
                    <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
                      <pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
                        <pic:nvPicPr>
                          <pic:cNvPr id="#{id}" name="Picture #{id}"/>
                          <pic:cNvPicPr/>
                        </pic:nvPicPr>
                        <pic:blipFill>
                          <a:blip cstate="print" r:embed="#{@file.reference}">
                            <a:extLst>
                              <a:ext uri="{28A0092B-C50C-407E-A947-70E740481C1C}">
                                <a14:useLocalDpi val="0" xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main"/>
                              </a:ext>
                            </a:extLst>
                          </a:blip>
                          <a:stretch>
                            <a:fillRect/>
                          </a:stretch>
                        </pic:blipFill>
                        <pic:spPr>
                          <a:xfrm>
                            <a:off x="0" y="0"/>
                            <a:ext cx="#{DocXify.cm2emu(@width_cm)}" cy="#{DocXify.cm2emu(@height_cm)}"/>
                          </a:xfrm>
                          <a:prstGeom prst="rect">
                            <a:avLst/>
                          </a:prstGeom>
                        </pic:spPr>
                      </pic:pic>
                    </a:graphicData>
                  </a:graphic>
                </wp:inline>
              </w:drawing>
            </w:r>
          </w:p>
        XML
      end
    end
  end
end
