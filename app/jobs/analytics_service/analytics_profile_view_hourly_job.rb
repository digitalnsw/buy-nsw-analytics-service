module AnalyticsService
  class AnalyticsProfileViewHourlyJob < SharedModules::ApplicationJob
    def perform
      hour = 1.hour.ago.utc.strftime('H_%Y-%m-%d_%H')
      counters = {}
      AnalyticsService::DataAtom.where(date_hour: hour, 'path.begins_with' => '/ict/supplier/profile/').each do |atom|
        if counters[atom.entity_id].nil?
          counters[atom.entity_id] = {
            total_view: 0,
            user_view: 0,
            buyer_view: 0,
          }
        end
        counters[atom.entity_id][:total_view] += 1
        counters[atom.entity_id][:user_view] += 1 if atom.user_roles.present?
        counters[atom.entity_id][:buyer_view] += 1 if atom.user_roles.present? && atom.user_roles.include?("buyer")
      end
      counters.each do |supplier_id, counter|
        AnalyticsService::ProfileViewCube.create(
          supplier_id: supplier_id,
          aggregation_span: hour,
          total_view_count: counter[:total_view],
          user_view_count: counter[:user_view],
          buyer_view_count: counter[:buyer_view],
        ).save
      end
    end
  end
end
