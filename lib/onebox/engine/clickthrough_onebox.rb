module Onebox
  module Engine
    class ClickThroughOnebox
      include Engine
      include OpenGraph

      matches do
        # /^https?:\/\/(?:www.)?clikthrough.com\/theater\/video\/\d+$/
        find "clickthrough.com"
      end

      private

      def extracted_data
        require "pry"
        binding.pry
        {
          url: @url,
          title: @body.title,
          description: @body.description
        }
      end
    end
  end
end
