require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tanakai'
  gem 'mechanize'
end

require 'tanakai'
require 'mechanize'

# SlackAppsScraper
class ProductsScraper < Tanakai::Base
  @name = 'slack_spider'
  @engine = :mechanize
  @start_urls = ['https://ng.oraimo.com/products/power/power-banks.html']

  def parse(response, url:, data: {})
    @base_uri = 'https://ng.oraimo.com/products/power/power-banks.html'
    response = browser.current_response

    response.css('.item.product.product-item').each do |app|

        browser.visit(@base_uri)
        app_response = browser.current_response

        item = {}
        item[:url] = app.css('.product-item-link').map{ |link| link['href'] }.join
        item[:name] = app.css('.product-item-link')&.text&.squish
        item[:image_url] = app.css('.product-image-photo').map{ |link| link['src'] }.join
        item[:old_price] = app.css('.price')[1]&.text&.squish&.delete('^0-9').to_i
        item[:current_price] = app.css('.price')[0]&.text&.squish&.delete('^0-9').to_i
        item[:reviews_count] = app.at_css('.action.view')&.text&.delete('^0-9').to_i

        save_to "products_url.json", item, format: :pretty_json, position: false
    end

  end
end

ProductsScraper.crawl!