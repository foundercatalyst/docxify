RSpec.describe DocXify do
  describe "A4 page constants" do
    it "match Word's A4 page size in twips" do
      expect(DocXify::A4_PORTRAIT_WIDTH).to eq(11_906)
      expect(DocXify::A4_PORTRAIT_HEIGHT).to eq(16_838)
      expect(DocXify::A4_LANDSCAPE_WIDTH).to eq(16_838)
      expect(DocXify::A4_LANDSCAPE_HEIGHT).to eq(11_906)
    end
  end

  describe "#cm2dxa" do
    it "should convert a value in centimetres to DXA" do
      expect(DocXify.cm2dxa(2.54)).to eq(1440)
    end

    it "should convert a decimal value in centimetres to DXA" do
      expect(DocXify.cm2dxa(1.27)).to eq(720)
    end

    it "should raise an ArgumentError if a negative value is supplied" do
      expect {
        DocXify.cm2dxa(-2.54)
      }.to raise_error(ArgumentError, "Value must be greater than or equal to 0")
    end
  end

  describe "#pt2halfpt" do
    it "should convert a value in points to half points" do
      expect(DocXify.pt2halfpt(12)).to eq(24)
    end

    it "should convert a decimal value in points to half points" do
      expect(DocXify.pt2halfpt(10.5)).to eq(21)
    end

    it "should raise an ArgumentError if a negative value is supplied" do
      expect {
        DocXify.pt2halfpt(-12)
      }.to raise_error(ArgumentError, "Value must be greater than or equal to 0")
    end
  end

  describe "#cm2emu" do
    it "should convert a value in centimetres to EMU" do
      expect(DocXify.cm2emu(2.54)).to eq(914400)
    end

    it "should convert a decimal value in centimetres to EMU" do
      expect(DocXify.cm2emu(1.27)).to eq(457200)
    end

    it "should raise an ArgumentError if a negative value is supplied" do
      expect {
        DocXify.cm2emu(-2.54)
      }.to raise_error(ArgumentError, "Value must be greater than or equal to 0")
    end
  end
end
