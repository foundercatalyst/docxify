require 'docxify/element/base'

RSpec.describe DocXify::Element::Base do
  describe "#to_s" do
    it "raises NotImplementedError" do
      base = DocXify::Element::Base.new(nil)
      expect {
        base.to_s
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#parse_simple_html" do
    it "parses simple HTML tags" do
      base = DocXify::Element::Base.new(nil)
      html = '<p>Hello, world!</p>'
      expected_result = [{ tag: 'p', content: 'Hello, world!' }]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
    end

    it "parses HTML tags with attributes" do
      base = DocXify::Element::Base.new(nil)
      html = '<a href="https://example.com">Click here</a>'
      expected_result = [{ tag: 'a', attributes: { href: 'https://example.com' }, content: 'Click here' }]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
    end

    it "parses content before HTML tags" do
      base = DocXify::Element::Base.new(nil)
      html = "Hello<b>world</b>"
      expected_result = ["Hello", { tag: "b", content: "world" }]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
    end

    it "parses content after HTML tags" do
      base = DocXify::Element::Base.new(nil)
      html = "<b>Hello</b>world"
      expected_result = [{ tag: "b", content: "Hello" }, "world"]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
    end

    it "handles self-closing HTML tags" do
      base = DocXify::Element::Base.new(nil)
      html = '<br/>'
      expected_result = [{ tag: 'br', content: '' }]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
      html = '<br />'
      expected_result = [{ tag: 'br', content: '' }]
      expect(base.send(:parse_simple_html, html)).to eq(expected_result)
    end
  end
end
