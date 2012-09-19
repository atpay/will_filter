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
                  b.th(field.to_s)
                end
              }

              results.each do |row|
                b.tr {
                  fields.each do |field|
                    b.td(row[field])
                  end
                }
              end
            }
          }
        }

        b.to_s
      end

      def options
        super.merge({
          :type => 'text/html', 
          :disposition => "attachment; filename=results.html"      
        })
      end
    end
  end
end
