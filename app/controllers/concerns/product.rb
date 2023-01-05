class Product
  # get products from shopify
  def get_products
    RestClient.get(
      "https://latori-teststore.myshopify.com/admin/api/2023-01/products.json",
      {
        'X-Shopify-Access-Token'=> ENV['ACCESS_TOKEN']
      }
    )
  end

  def update_product?(product_id, product)
    resp = RestClient.put(
      "https://latori-teststore.myshopify.com/admin/api/2023-01/products/#{product_id}.json",
      {
        product: {
          title:      product['data']['resource']['title'],
          body_html:  product['data']['resource']['description'],
          images:     product['data']['resource']['images'],
          status:     product['data']['resource']['status'] == 'inactive' ? 'draft' : product['data']['resource']['status'],
          tags:       product['data']['resource']['tags'].split(',')
        }
      },
      {
        'X-Shopify-Access-Token'=> ENV['ACCESS_TOKEN']
      }
    )
    resp.code == 200
  end

  # add a product on shopify
  def add_product?(product)
    resp = RestClient.post(
      "https://latori-teststore.myshopify.com/admin/api/2023-01/products.json",
      {
        product: {
          title:      product['data']['resource']['title'],
          body_html:  product['data']['resource']['description'],
          images:     product['data']['resource']['images'],
          status:     product['data']['resource']['status'] == 'inactive' ? 'draft' : product['data']['resource']['status'],
          tags:       product['data']['resource']['tags'].split(',')
        }
      },
      {
        'X-Shopify-Access-Token'=> ENV['ACCESS_TOKEN']
      }
    )
    resp.code == 201
  end

  # delete a product from shopify
  def delete_product?(product_id)
    resp = RestClient.delete(
      "https://latori-teststore.myshopify.com/admin/api/2023-01/products/#{product_id}.json",
      {
        'X-Shopify-Access-Token'=> ENV['ACCESS_TOKEN']
      }
    )

    resp.code == 200
  end

  # check if the product from json file exists on shipify
  def exist_product?(product)
    product_id = nil

    resp = RestClient.get(
      "https://latori-teststore.myshopify.com/admin/api/2023-01/products.json",
      {
        'X-Shopify-Access-Token'=> ENV['ACCESS_TOKEN']
      }
    )

    exist_products = JSON.parse(resp)['products']

    if exist_products.present?
      exist_products.each do |exist_product|
        if exist_product['title'] == product['data']['resource']['title']
          product_id = exist_product['id']
          break
        end
      end
    end

    product_id
  end
end