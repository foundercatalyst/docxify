require "spec_helper"
require "docxify/element/file"

RSpec.describe DocXify::Element::File do
  let(:document) { double("document") }

  describe "#initialize" do
    context "when file path is provided" do
      it "loads file data from the given file path" do
        file_path = "spec/fixtures/sample.png"
        file = DocXify::Element::File.new(document, file_path)

        expect(file.data).to eq(File.read(file_path, mode: "rb"))
        expect(file.filename).to eq("sample.png")
      end
    end

    context "when file data is provided" do
      it "loads file data from the given data" do
        file_data = "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00d\x00\x00\x00d\b\x03\x00\x00\x00G<ef\x00\x00\x00iPLTE1`\x97\xFF\xFF\xFF\x98\xAF\xCBKt\xA4\xCB\xD7\xE5\xB1\xC3\xD8\xE5\xEB\xF2e\x88\xB1~\x9B\xBE>j\x9D>j\x9E\x8B\xA5\xC4\xF2\xF5\xF8X~\xABe\x87\xB1\xF2\xF5\xF9\x7F\x9C\xBE\xD9\xE1\xEB\xBE\xCD\xDFX~\xAA\xA5\xB9\xD2\x8B\xA5\xC5r\x92\xB8\xB2\xC3\xD8\xBF\xCD\xDFX}\xAB\xD8\xE1\xEB\xA5\xB9\xD1r\x92\xB7\x8B\xA6\xC5\xBE\xCD\xDE\x7F\x9B\xBE\x98\xB0\xCBq\x91\xB7\xA5\xBA\xD2i\xC0\xCF]\x00\x00\x01\xA3IDATx^\xED\xD4\xD9\xAA\xDC0\f\xC7a\xFD%\xD9\xCE\x9EY\xCF\xDA\xFD\xFD\x1F\xB2D\xC8\t\x1DrZB/\nE\xDFMf2\x81\x9F\xB1\x9C\xA1\x7F+\x84\x10B\b!\x84\x10B\b\xA1\xEB\x93\xEAM\xC8}b\xBE\x93\x11f\xEE\xC8\xF8\xE7\x96M?\xF9\xADB\xAEg\xF7D\xBB\xAE\x19\xE6\xDD#\x19\x80\x15i\x02\xC0\x1Ey\xB6\xBB\x02w\x11\xFB\x99\xC9e\xB8D{$\x03\xCA\xB7\f\xDC\xAD1\x02\x00\xAF\x91\x99L;\xD4HN\xE9K\x06\xF41\x92\x93ih\xCF\t\xF8LD\xED\e\xE6\xBA\xE47\x9C\xD7\b\x8A?U#iI*P\x1E\"J\xBF\xC1\xBE9\x85\xB9>\xDE\x03e\x8D\xE8\xBA\x1D[\x84\np?\x12\xE9}\x1An\x02\x9A\x16`\x8F$\xA0\xB3\x1C^j\xC4\xF7\x94\x8FD\xDA\f\xE4\xD4\xC86`!\xC5\\\x83\x03\xD8\xEE\x9E\xB9F|\xF7\x9A\xC7\x99|5\x1D\xED\x12\xC5B\xC7mI=P<\xC2KO\x80\xA6F.\"\xD2\x0F\x80<D\x9C\xD0\a\xAEl\x9D\x86\x88\xBE\xDB\xA5\x05n\xDB\xD6\x15:a\xEE<R}\xA3\x87\xC8\x90\x8D\xD0\xC7\xBA\xD3\x80\xB9\xB3\xDD:\xAB*\x96/\x16!\x85RF\xA2_\"Z\x88\x8E\xCC\xE4u\x1A\xEB)\e\xA9\xC5\xAAx\xA4\x00= k\xE4ED\xC8\x1C\x88d\x9C\xEB\xC4G:\x01?N\v\xE0\xE2\x11\x1A`\xE7x\e\xBC;\xF8\x9E\\^I\x18\xC8DZ'\xA7\x98;\x8F0\xEC\xB2\eI\x93\xB1\xA5Nf\xFC\xE8\b\xBB'\x12@\xD7\xB7\xA7\xF1Hk\xF9\xDD\x88\xCB\x7F\xFC\xEF\"y\x1E|\x96v\xFC=\r\xA8GH\x91\xFE*\xE2\xAE\xE5\xDA\xD1\x7F \x84\x10B\b!\x84\x10B\b\xE1'\xA4\xF8\x0FG-\xF4O\xEA\x00\x00\x00\x00IEND\xAEB`\x82".b

        file = DocXify::Element::File.new(document, file_data)

        expect(file.data).to eq(file_data)
        expect(file.filename).to match(/[a-f0-9]{20}\.png/)
      end

      it "raises an error for unsupported file types" do
        file_data = "unsupported file data"

        expect {
          DocXify::Element::File.new(document, file_data)
        }.to raise_error(ArgumentError, "Unsupported file type - images must be PNG or JPEG")
      end
    end
  end

  describe "#reference" do
    it "returns the reference of the file" do
      file_path = "spec/fixtures/sample.png"
      file = DocXify::Element::File.new(document, file_path)

      expect(file.reference).to match(/image-[a-f0-9]{8}/)
    end
  end

  describe "#contains_png_image?" do
    it "returns true if the data contains a PNG image" do
      png_signature = "\211PNG\r\n\032\n".b
      file_data = png_signature + "image data"
      file = DocXify::Element::File.new(document, file_data)

      expect(file.contains_png_image?(file_data)).to be_truthy
    end
  end

  describe "#contains_jpeg_image?" do
    it "returns true if the data contains a JPEG image" do
      jpeg_start = "\xFF\xD8".b
      jpeg_end = "\xFF\xD9".b
      file_data = jpeg_start + "image data" + jpeg_end
      file = DocXify::Element::File.new(document, file_data)

      expect(file.contains_jpeg_image?(file_data)).to be_truthy
    end
  end
end
