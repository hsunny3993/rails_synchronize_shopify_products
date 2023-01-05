class ProductJsonWorker
  include Sidekiq::Worker
  sidekiq_options retry: false,
                  lock: :until_executed,
                  unique_across_queues: true

  def perform
    json_data_list = Rails.cache.redis.get("json_data_list")

    unless json_data_list.empty?
      json_uuids = json_data_list.split(',')
      Rails.logger.info json_uuids.inspect

      json_uuids.each do |json_uuid|
        begin
          json_data = Rails.cache.redis.get("json_data_#{json_uuid}")
          products = JSON.parse(json_data)
          puts products.inspect

          products.each do |product|
            exist_product_id = Product.new.exist_product?(product)

            if exist_product_id.present?
              if product['data']['resource']['status'] == 'deleted'
                Product.new.delete_product?(exist_product_id)
              else
                Product.new.update_product?(exist_product_id, product)
              end
            else
              Product.new.add_product?(product)
            end

          end

          # delete processed json data from redis
          Rails.cache.delete("json_data_#{json_uuid}")
        rescue
          Rails.logger.info "Json data is incorrect"
        end
      end
    end

    # delete list of json data
    Rails.cache.delete("json_data_list")
  end
end
