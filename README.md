# DocXify

If you've ever wanted to generate a Word Document containing a letter or a contract (not a full page layout advert or advanced formatting like that), DocXify is the gem you need in your life.

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add docxify
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install docxify
```

## Usage

```ruby
@docx = DocXify::Document.new(page_width: DocXify::A4_PORTRAIT_WIDTH, page_height: DocXify::A4_PORTRAIT_HEIGHT)

@docx.default_styling font: "Serif font here", size: 14, color: "#040404"

@docx.add_paragraph "Title", font: "Something", size: 18, color: "#00000", after: 18
@docx.add_paragraph "Body copy"
@docx.add_paragraph "This is <b>bold</b>, <i>Italic</i> and <u>Underlined</u>."
@docx.add_paragraph "Text can also contain <a href='foo'>Links</a>."
@docx.add_paragraph "Centred text", align: :center
@docx.add_paragraph "Highlighted text", background: "#FFFF99"
@docx.add_paragraph "This won't show as <b>bold</b>", inline_styling: false

@docx.add_paragraph "\t1.1.1\tBody copy", tab_stops_cm: [1, 2]
@docx.add_paragraph "{CHECKBOX_EMPTY}\tEmpty checkbox", tab_stops_cm: [2]
@docx.add_paragraph "{CHECKBOX_CHECKED}\tChecked checkbox", tab_stops_cm: [2]

@docx.add_divider

@docx.add_image "file_path or data", align: :right, height_cm: 2, width_cm: 4, after: 18

@docx.add_page_break

@docx.page_layout width: DocXify::A4_PORTRAIT_HEIGHT, height: DocXify::A4_PORTRAIT_WIDTH, orientation: :landscape

rows = []
rows << [
  DocXify::Element::TableCell.new("<b>Header 1</b>"),
  DocXify::Element::TableCell.new("<b>Header 2</b>")
  DocXify::Element::TableCell.new("<b>Header 3</b>")
  DocXify::Element::TableCell.new("<b>Header 4</b>", width_cm: 10)
]
rows << [
  DocXify::Element::TableCell.new("Content 1", valign: :center, align: :left, nowrap: true, colspan: 3),
  DocXify::Element::TableCell.new("Rowspan <b>here</b>", rowspan: true) # merges until a "nil" cell
]
rows << [
  DocXify::Element::TableCell.new("Secondary 1")
  DocXify::Element::TableCell.new("Secondary 2")
  DocXify::Element::TableCell.new("Secondary 3")
  DocXify::Element::TableCell.new(nil) # Word requires that there's an empty cell merged with the previous rowspan
]
container.add_table rows

docx_binary_data = @docx.render
# or
@docx.render "file_path"

# All of the above add_* are also available as objects for more dynamic control

para = DocXify::Element::Paragraph.new()
para.content = "This is <b>bold</b>, <i>Italic</i> and <u>Underlined</u>. It can also contain <a href='foo'>Links</a>."
para.font = "Something"
para.size = 18
para.color = "#040404"
para.background = "#FFFF99"
para.align = :center
@docx.add para
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Overall architecture

The main object created by users is a `DocXify::Document`. This builds up a `@content` instance variable containing an array of all of the elements. Each element has a `to_s` method that will convert it's current state to a string, ready for insertion in to a complete document.

The `render` method on a `DocXify::Document` will generate a complete `document.xml` (Word terminology not a Ruby method) by creating a template and iterating each `@content` item. It will then create a `DocXify::Container` with that `document.xml` to generate a complete Zipped DocX file, and call it's `render` method to generate an in-memory file. This is then either returned to the `render` caller, or if a file path was passed as the first attribute, then it writes it out.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/foundercatalyst/docxify>.
