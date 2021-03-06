module AnalyticsService
  class AnalyticsProfileViewMonthlyJob < SharedModules::ApplicationJob
    def perform
      # FIXME: this line timeouts so changed to non soa
      # supplier_ids = ::SharedResources::RemotePublicSeller.all_active.map(&:id)
      supplier_ids = Seller.live.pluck(:id)
      range = 1.month.ago.utc.strftime('D_%Y-%m')
      counters = {}
      supplier_ids.each do |supplier_id|
        AnalyticsService::ProfileViewCube.where(supplier_id: supplier_id, "aggregation_span.begins_with" => range).each do |cube|
          if counters[cube.supplier_id].nil?
            counters[cube.supplier_id] = {
              total_view: 0,
              user_view: 0,
              buyer_view: 0,
            }
          end
          counters[cube.supplier_id][:total_view] += cube.total_view_count
          counters[cube.supplier_id][:user_view] += cube.user_view_count
          counters[cube.supplier_id][:buyer_view] += cube.buyer_view_count
        end
      end
      counters.each do |supplier_id, counter|
        AnalyticsService::ProfileViewCube.create(
          supplier_id: supplier_id,
          aggregation_span: range.gsub('D', 'M'),
          total_view_count: counter[:total_view],
          user_view_count: counter[:user_view],
          buyer_view_count: counter[:buyer_view],
        ).save
      end
    end
  end
end
