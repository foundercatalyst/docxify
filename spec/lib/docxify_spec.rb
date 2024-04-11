RSpec.describe Docxify do
  describe "#cm" do
    it "should convert a value in centimetres to DXA" do
      expect(Docxify.cm(2.54)).to eq(1440)
    end
  end
end
