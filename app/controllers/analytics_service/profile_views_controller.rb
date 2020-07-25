require_dependency "analytics_service/application_controller"

module AnalyticsService
  class ProfileViewsController < AnalyticsService::ApplicationController

    def get_params
      @supplier_id = params[:supplier_id].to_i
      raise SharedModules::NotAuthorized unless @supplier_id == session_user.seller_id

      interval = params[:interval]
      raise "Invalid Interval" unless interval.in? ["hourly", "daily", "monthly"]


      if interval == 'hourly'
        days = params[:days]
        raise "Invalid Range" unless days.is_a?(Array) && days.size.in?(1..7)
        raise "Invalid Day Format" unless days.all? { |day| /^\d\d\d\d-\d\d-\d\d$/ =~ day }
        @ranges = days.map{ |day| "H_" + day }
      elsif interval == 'daily'
        months = params[:months]
        raise "Invalid Range" unless months.is_a?(Array) && months.size.in?(1..7)
        raise "Invalid Month Format" unless months.all? { |month| /^\d\d\d\d-\d\d$/ =~ month }
        @ranges = months.map{ |month| "D_" + month }
      elsif interval == 'monthly'
        years = params[:years]
        raise "Invalid Range" unless years.is_a?(Array) && years.size.in?(1..7)
        raise "Invalid Month Format" unless years.all? { |year| /^\d\d\d\d$/ =~ year }
        @ranges = years.map{ |year| "M_" + year }
      end
    end

    def index
      get_params

      response = {}
      @ranges.each do |range|
        AnalyticsService::ProfileViewCube.where(supplier_id: @supplier_id, "aggregation_span.begins_with" => range).each do |cube|
          response[cube.aggregation_span.partition('_').last] = {
            total_view: cube.total_view_count,
            user_view:  cube.user_view_count,
            buyer_view: cube.buyer_view_count,
          }
        end
      end

      render json: response
    end
  end
end
