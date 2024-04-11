require_relative "docxify/version"

module Docxify
  class Error < StandardError; end

  UNITS_PER_CM = (1440 / 2.54)

  def self.cm(value)
    value = value.to_f
    value * UNITS_PER_CM
  end
end
