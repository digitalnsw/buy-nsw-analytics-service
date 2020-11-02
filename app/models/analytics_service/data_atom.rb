module AnalyticsService
  class DataAtom
    include Dynamoid::Document

    table name: :data_atoms, key: :date_hour, capacity_mode: :on_demand
    range :sent_at, :datetime

    field :user_agent
    field :referrer
    field :url
    field :host
    field :path
    field :entity_id, :integer
    field :user_id, :integer
    field :user_email
    field :user_roles, :set, of: :string
    field :action
    field :true_user_id
    field :remote_ip

    local_secondary_index range_key: :user_agent
    local_secondary_index range_key: :entity_id
    local_secondary_index range_key: :user_id
    local_secondary_index range_key: :action
    local_secondary_index range_key: :path
  end
end
