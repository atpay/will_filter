module WillFilter
  module Exporter
    class XML < Base
      def to_data
        results.to_xml(:root => @filter.results.first.class.name.tableize)
      end

      def options
        super.merge(:type => "text/xml")
      end
    end
  end
end
