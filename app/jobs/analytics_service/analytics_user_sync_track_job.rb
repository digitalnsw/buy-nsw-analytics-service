module AnalyticsService
  class AnalyticsUserSyncTrackJob < SharedModules::ApplicationJob
    def import hour
      AnalyticsService::UserSync.where(date_hour: hour).each do |record|
        begin
          AnalyticsService::UserSyncTrack.create(
            user_id: record.user_id,
            sent_at: record.sent_at,
            status: record.status,
            response: record.response,
            token: record.token,
            url: record.url,
            action: record.action,
          ).save if record.user_id.present? && record.sent_at.present?
        rescue => e
          Airbrake.notify_sync(e.message, {
            date_hour: hour,
            trace: e.backtrace.select{|l|l.match?(/buy-nsw/)},
          })
        end
      end
    end

    def perform
      import 1.hour.ago.utc.strftime('H_%Y-%m-%d_%H')
    end
  end
end
