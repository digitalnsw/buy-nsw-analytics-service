module AnalyticsService
  class ProfileViewCube
    include Dynamoid::Document

    table name: :profile_view_cube, key: :supplier_id, capacity_mode: :on_demand
    range :aggregation_span

    field :total_view_count, :integer
    field :user_view_count, :integer
    field :buyer_view_count, :integer
  end
end
