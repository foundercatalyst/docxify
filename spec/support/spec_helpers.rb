module DocXify
  module SpecHelpers
    def docx_equal(contents1, contents2)
      # Unzip both sets of content
      zip1 = Zip::File.open_buffer(contents1)
      zip2 = Zip::File.open_buffer(contents2)

      # This isn't ideal, it could have two separate lists of files the same size
      # But given we're generating both files, that's highly unlikely
      return false if zip1.count != zip2.count

      zip1.each do |entry|
        file1 = entry.get_input_stream.read
        file2 = zip2.find_entry(entry.name).get_input_stream.read
        return false if file1 != file2
      end

      true
    end
  end
end

RSpec::Matchers.define :be_same_docx do |expected|
  match do |actual|
    docx_equal(actual, expected)
  end
end
