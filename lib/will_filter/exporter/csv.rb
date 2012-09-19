module WillFilter
  module Exporter
    class CSV < Base
      def results
        @filter.results.collect { |record|
          fields.collect { |field|
            record.send(field).to_s
          }
        }
      end

      def to_data
        ::CSV.generate do |csv|
          csv << fields

          results.each do |row|
            csv << row
          end
        end
      end

      def options
        super.merge({
          :type => 'text/csv; charset=utf-8; header=present', 
          :disposition => "attachment; filename=results.csv"      
        })
      end
    end
  end
end
