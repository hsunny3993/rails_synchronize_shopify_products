class ProductsController < ApplicationController
  require 'securerandom'

  def index
    response = Product.new.get_products
    @products = JSON.parse(response)['products']
  end

  def import_json
    json_file = product_params[:json_file]

    # store uploaded json data into redis with uuid
    uuid = SecureRandom.uuid
    cached_json_list = Rails.cache.redis.get("json_data_list")

    if cached_json_list.present?
      Rails.cache.redis.set("json_data_list", "#{cached_json_list},#{uuid}")
    else
      Rails.cache.redis.set("json_data_list", uuid)
    end

    Rails.cache.redis.set("json_data_#{uuid}", json_file.read)

    redirect_to root_path
  end

  private
  def product_params
    params.require(:product).permit(:json_file)
  end
end
