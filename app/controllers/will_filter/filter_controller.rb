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
  class FilterController < ApplicationController
    before_filter :find_or_load_filter

    def show
      @filters = @filter.results
    end

    def create
      raise WillFilter::FilterException.new("Saving functions are disabled") unless WillFilter::Config.saving_enabled?

      @filter.save
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def update
      raise WillFilter::FilterException.new("Update functions are disabled") unless  WillFilter::Config.saving_enabled?

      @filter.save
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def destroy
      raise WillFilter::FilterException.new("Delete functions are disabled") unless  WillFilter::Config.saving_enabled?

      @filter.destroy
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def update_condition
      @filter.condition_at(params[:at_index].to_i).reset_values
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def remove_condition
      @filter.remove_condition(params[:at_index].to_i)
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def add_condition
      index = params[:after_index].to_i
      if index == -1
        @filter.add_default_condition_at(@filter.size)
      else
        @filter.add_default_condition_at(params[:after_index].to_i + 1)
      end
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def remove_all_conditions
      @filter.remove_all
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end
  
    def load_filter
      @filter.load_filter!(params[:wf_key])
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => @filter})
    end

    private
    def find_or_load_filter
      @filter = WillFilter::Filter.find_and_initialize(params[:id], params[:filter])
    end
  end
end
