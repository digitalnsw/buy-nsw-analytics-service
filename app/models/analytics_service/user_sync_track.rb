module AnalyticsService
  class UserSyncTrack
    include Dynamoid::Document

    table name: :user_sync_track, key: :user_id, capacity_mode: :on_demand
    range :sent_at, :datetime

    field :status
    field :response
    field :token
    field :url
    field :action

    def visit_date_time
      sent_at.strftime("%d/%b/%Y %H:%M:%S")
    end

    local_secondary_index range_key: :status
  end
end
