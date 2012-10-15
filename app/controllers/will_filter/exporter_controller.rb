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

require 'csv'

module WillFilter
  class ExporterController < ApplicationController
    before_filter :check_exports_enabled

    def index
      @wf_filter = WillFilter::Filter.deserialize_from_params(params)
      render :layout => false
    end
  
    def fields
      @wf_filter = WillFilter::Filter.deserialize_from_params(params)
      @exporter = @wf_filter.exporter
      render :layout => false
    end

    def export
      params[:page] = 1
      params[:wf_per_page] = 10000 # max export limit
  
      @wf_filter = WillFilter::Filter.deserialize_from_params(params)
      
      data, opts = @wf_filter.exporter.process
      send_data(data, opts)
    end  

    private
    def check_exports_enabled
      unless WillFilter::Config.export_options[:controller]
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
