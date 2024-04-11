module DocXify
  module SpecHelpers
    def docx_equal(contents1, contents2)
      zip1 = Zip::File.open_buffer(contents1)
      zip2 = Zip::File.open_buffer(contents2)

      # Check that both zips contain exactly the same list of files
      return false if zip1.entries.map(&:name) != zip2.entries.map(&:name)

      # Check that the files in each zip when decompressed are exactly the same
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
