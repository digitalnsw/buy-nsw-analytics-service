module AnalyticsService
  class SsoLog
    include Dynamoid::Document

    table name: :sso_log, key: :date_hour, capacity_mode: :on_demand
    range :sent_at, :datetime

    field :user_id, :integer
    field :uuid
    field :action
    field :host
    field :redirect_string
    field :login_url
    field :token

    local_secondary_index range_key: :user_id
    local_secondary_index range_key: :action
  end
end
