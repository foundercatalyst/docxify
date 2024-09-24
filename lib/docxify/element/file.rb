require "digest/sha1"

module DocXify
  module Element
    class File < Base
      PNG_SIGNATURE = "\x89PNG\r\n\u001A\n".b.freeze
      JPEG_START = "\xFF\xD8".b.freeze
      JPEG_END = "\xFF\xD9".b.freeze

      attr_accessor :data, :filename

      def initialize(file_path_or_data)
        super()
        load_file_data(file_path_or_data)
      end

      def load_file_data(file_path_or_data)
        if ::File.exist?(file_path_or_data)
          file_path_or_data = ::File.read(file_path_or_data, mode: "rb")
        end

        if contains_png_image?(file_path_or_data)
          @data = file_path_or_data
          @filename = "#{Digest::SHA1.hexdigest(@data)}.png"
        elsif contains_jpeg_image?(file_path_or_data)
          @data = file_path_or_data
          @filename = "#{Digest::SHA1.hexdigest(@data)}.jpg"
        else
          raise ArgumentError.new("Unsupported file type - images must be PNG or JPEG")
        end
      end

      def reference
        "image-#{Digest::SHA1.hexdigest(@data)[0, 8]}"
      end

      def to_s
        "<Relationship Id=\"#{reference}\" Target=\"media/#{filename}\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image\"/>"
      end

      def contains_png_image?(data)
        data[0, 8] == PNG_SIGNATURE
      end

      def contains_jpeg_image?(data)
        data[0..1] == JPEG_START && data[-2..] == JPEG_END
      end
    end
  end
end
