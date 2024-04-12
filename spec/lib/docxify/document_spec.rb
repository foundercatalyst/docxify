require "highline/import"

require "spec_helper"

RSpec.describe DocXify::Document do
  it "generates a sample document correctly" do
    docx = DocXify::Document.new(page_width: DocXify::A4_PORTRAIT_WIDTH, page_height: DocXify::A4_PORTRAIT_HEIGHT)

    docx.default_styling font: "Times New Roman", size: 14, color: "#040404"

    docx.add_paragraph "Title", font: "Arial", size: 18, color: "#00000"
    docx.add_paragraph "Body copy"
    # @docx.add_paragraph "This is <b>bold</b>, <i>Italic</i> and <u>Underlined</u>."
    # @docx.add_paragraph "Text can also contain <a href='foo'>Links</a>."
    # @docx.add_paragraph "Centred text", align: :center
    # @docx.add_paragraph "Highlighted text", background: "#FFFF99"
    # @docx.add_paragraph "This won't show as <b>bold</b>", inline_styling: false

    # docx.add_paragraph "\t1.1.1\tBody copy", tab_stops_cm: [1, 2]
    # docx.add_paragraph "{CHECKBOX_EMPTY}\tEmpty checkbox", tab_stops_cm: [2]
    # docx.add_paragraph "{CHECKBOX_CHECKED}\tChecked checkbox", tab_stops_cm: [2]

    docx.add_page_break
    docx.add_divider

    file = docx.add_file "spec/fixtures/sample.png"

    # Use allow_any_instance_of to assign them different but known IDs for exact recreatabilty of the sample document
    allow_any_instance_of(DocXify::Element::Image).to receive(:id).and_return("12345678")
    docx.add_image file, height_cm: 2, width_cm: 4

    allow_any_instance_of(DocXify::Element::Image).to receive(:id).and_return("12345679")
    docx.add_image file, align: :center, height_cm: 2, width_cm: 4

    allow_any_instance_of(DocXify::Element::Image).to receive(:id).and_return("12345680")
    docx.add_image file, align: :right, height_cm: 2, width_cm: 4

    # headers = [
    #   DocXify::Element::TableCell.new("<b>Header 1</b>"),
    #   DocXify::Element::TableCell.new("<b>Header 2</b>")
    # ]
    # row = [
    #   DocXify::Element::TableCell.new("Content <b>here</b>", valign: :center, align: :left, nowrap: true, colspan: 3),
    #   DocXify::Element::TableCell.new("Content <b>here</b>")
    # ]
    # rows = [row]
    # docx.add_table headers, rows, expand: :full

    docx_binary_data = docx.render
    sample_data = File.read("spec/fixtures/sample.docx", mode: "rb")
    docs_are_same = docx_equal(docx_binary_data, sample_data)

    if !docs_are_same && $stdin.tty?
      input = ask "Do you want to copy the sample document over the fixtures? (YES/no):"
      if input.downcase.split("").first == "y" || input.strip == ""
        File.write("spec/fixtures/sample.docx", docx_binary_data, mode: "wb")
        sample_data = docx_binary_data
      else
        File.write("tmp/test_run.docx", docx_binary_data, mode: "wb")
      end
    end

    expect(docs_are_same).to be_truthy
  end
end
