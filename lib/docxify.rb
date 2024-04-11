require_relative "docxify/version"
require_relative "docxify/document"
require_relative "docxify/container"
require_relative "docxify/template"
require_relative "docxify/element/base"
require_relative "docxify/element/divider"
require_relative "docxify/element/image"
require_relative "docxify/element/numbered_list_item"
require_relative "docxify/element/page_break"
require_relative "docxify/element/paragraph"
require_relative "docxify/element/table"

module DocXify
  class Error < StandardError; end

  UNITS_PER_CM = (1440 / 2.54)
  A4_PORTRAIT_WIDTH = 11_906 # cm2dxa(21)
  A4_PORTRAIT_HEIGHT = 15_840 # cm2dxa(29.7)
  A4_LANDSCAPE_WIDTH = A4_PORTRAIT_HEIGHT
  A4_LANDSCAPE_HEIGHT = A4_PORTRAIT_WIDTH

  # Used for most sizes
  def self.cm2dxa(value)
    value = value.to_f
    raise ArgumentError, "Value must be greater than or equal to 0" if value < 0

    value * UNITS_PER_CM
  end

  # Used for font sizes
  def self.pt2halfpt(value)
    value = value.to_f
    raise ArgumentError, "Value must be greater than or equal to 0" if value < 0

    value * 2
  end

  # Used for image sizes
  def self.cm2emu(value)
    value = value.to_f
    raise ArgumentError, "Value must be greater than or equal to 0" if value < 0

    value * 360000
  end
end
