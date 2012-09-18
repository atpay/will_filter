module WillFilter
  module Exporter
    class HTML < Base
      def to_data
        b = Builder::XmlMarkup.new
        b.instruct!
        b.html { 
          b.body {
            b.table {
              b.tr {
                fields.each do |field|
                  b.th(field)
                end
              }

              results.each do |row|
                fields.each do |field|
                  b.td(row[field])
                end
              end
            }
          }
        }

        b.to_s
      end
    end
  end
end
