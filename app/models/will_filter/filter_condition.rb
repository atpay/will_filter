#--
# Copyright (c) 2010-2012 Michael Berkovich
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module WillFilter
  class FilterCondition < ActiveRecord::Base
    belongs_to :filter
    serialize :values

    validate_presence_of :operator, 
      :container_type, 
      :filter

    def values
      super || []
    end

    def operator
      self[:operator].to_sym
    end

    def container
      @container ||= WillFilter::Config.containers[self[:container_type]].constantize.new(filter, self, operator, values)
    end

    def full_key
      attr_name, table_name = key.split(".", 2).reverse
      table_name = (table_name ||= filter.table_name).split(".").first
  
      raise Exception unless table_name.camelcase.constantize.column_names.include? attr_name

      "#{table_name}.#{attr_name}"
    end
  end
end
