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
        user_agent: sanitize(full_sanitize(params[:user_agent])),
        referrer: request.referer,
        url: sanitize(full_sanitize(params[:url])),
        host: uri.host,
        path: uri.path,
        user_id: session_user&.id,
        # user_email: session_user&.email,
        user_roles: session_user&.roles,
        entity_id: uri.path.match(/\d+/)&.to_s.to_i,
        action: sanitize(full_sanitize(params[:action])),
        true_user_id: true_user&.id,
        remote_ip: { ip: request.remote_ip.to_s, x_forwaded_for: request.headers['X-Forwarded-For'] }.to_json,
      )
      data_atom.save

      render json: { }, status: :created
    end
  end
end
