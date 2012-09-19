module WillFilter
  module Exporter
    class JSON < Base
      def to_data
        results.to_json
      end

      def options
        super.merge(:type => "text/json")
      end
    end
  end
end
