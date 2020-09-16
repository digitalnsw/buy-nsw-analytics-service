module AnalyticsService
  class UserSync
    include Dynamoid::Document

    table name: :user_syn, key: :date_hour, capacity_mode: :on_demand
    range :sent_at, :datetime

    field :user_id, :integer
    field :status
    field :response

    local_secondary_index range_key: :user_id
    local_secondary_index range_key: :status
  end
end
