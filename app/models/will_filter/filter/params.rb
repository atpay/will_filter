module WillFilter
  module Params
    extend ActiveSupport::Concern

    included do
      class_eval do
        def self.deserialize_from_params(params, update={})
          params = prefixed_params(params).merge(update)

          params[:wf_type] = self.name unless params[:wf_type]
          filter_class = params[:wf_type].constantize
          filter_instance = filter_class.new

          unless filter_instance.kind_of?(WillFilter::Filter)
            raise WillFilter::FilterException.new("Invalid filter class. Filter classes must extand WillFilter::Filter.")
          end  
          
          if WillFilter::Config.require_filter_extensions?
            filter_instance.deserialize_from_params(params) 
          else  
            filter_class.new(params[:wf_model]).deserialize_from_params(params) 
          end
        end

        def self.params_prefix
          name.tableize unless self == WillFilter::Filter
        end

        def self.prefixed_params(params)
          HashWithIndifferentAccess.new(params_prefix.nil? ? params : params[params_prefix])
        end
      end
    end

    #############################################################################
    # Serialization 
    #############################################################################
    def serialize_to_params(merge_params = {})
      params = {}
      params[:wf_type]          = self.class.name
      params[:wf_match]         = match
      params[:wf_model]         = model_class_name
      params[:wf_order]         = order
      params[:wf_order_type]    = order_type
      params[:wf_per_page]      = per_page
      params[:wf_export_fields] = fields.join(',')
      params[:wf_export_format] = format
      
      0.upto(size - 1) do |index|
        condition = condition_at(index)
        condition.serialize_to_params(params, index)
      end

      self.class.prefixed_params(params).merge(merge_params)
    end
    alias_method :to_params, :serialize_to_params

    def deserialize_from_params(params, update={})
      params = self.class.prefixed_params(params).merge(update)

      @conditions = []
      @match                = params[:wf_match]       || :all
      @key                  = params[:wf_key]         || self.id.to_s

      self.model_class_name = params[:wf_model]       if params[:wf_model]
      
      @per_page             = params[:wf_per_page]    || default_per_page
      @page                 = params[:page]           || 1
      @order_type           = params[:wf_order_type]  || default_order_type
      @order                = params[:wf_order]       || default_order
      
      self.id   =  params[:wf_id].to_i  unless params[:wf_id].blank?
      self.name =  params[:wf_name]     unless params[:wf_name].blank?
      
      @fields = []
      unless params[:wf_export_fields].blank?
        params[:wf_export_fields].split(",").each do |fld|
          @fields << fld.to_sym
        end
      end
  
      if params[:wf_export_format].blank?
        self.format = :html
      else  
        self.format = params[:wf_export_format]
      end
      
      i = 0
      while params["wf_c#{i}"] do
        conditon_key = params["wf_c#{i}"]
        operator_key = params["wf_o#{i}"]
        values = []
        j = 0
        while params["wf_v#{i}_#{j}"] do
          values << params["wf_v#{i}_#{j}"]
          j += 1
        end
        i += 1
        add_condition(conditon_key, operator_key.to_sym, values)
      end
  
      if params[:wf_submitted] == 'true'
        validate!
      end

      if WillFilter::Config.user_filters_enabled? and WillFilter::Config.current_user
        self.user_id = WillFilter::Config.current_user.id
      end
  
      self
    end
    alias_method :from_params, :deserialize_from_params
  end

end
