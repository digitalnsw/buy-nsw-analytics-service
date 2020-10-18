require_dependency "analytics_service/application_controller"

module AnalyticsService
  class ReportController < AnalyticsService::ApplicationController
    skip_before_action :verify_authenticity_token, raise: false, only: [:create]
    include SharedModules::Serializer

    def create
      uri = URI.parse( params[:url] )
      data_atom = AnalyticsService::DataAtom.create(
        date_hour: Time.now.utc.strftime('H_%Y-%m-%d_%H'),
        sent_at: Time.now.utc,
        user_agent: full_sanitize params[:user_agent],
        referrer: request.referer,
        url: full_sanitize params[:url],
        host: uri.host,
        path: uri.path,
        user_id: session_user&.id,
        # user_email: session_user&.email,
        user_roles: session_user&.roles,
        entity_id: uri.path.match(/\d+/)&.to_s.to_i,
        action: full_sanitize params[:action],
      )
      data_atom.save

      render json: { }, status: :created
    end
  end
end
