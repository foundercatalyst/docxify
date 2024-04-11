module DocXify
  module Element
    class Base
      def to_s(container = nil)
        raise NotImplementedError
      end
    end
  end
end
