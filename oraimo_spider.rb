require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tanakai'
  # gem 'mechanize'
end

require 'tanakai'
require 'nokogiri'

# SlackAppsScraper
class ProductsScraper < Tanakai::Base
  @name = 'product_spider'
  @engine = :selenium_firefox
  @start_urls = ['https://ng.oraimo.com/oraimo-slice-link-10000mah-12w-fast-charge-3-in-1-portable-power-bank-with-built-in-lightning-type-c-micro-usb-cable.html']

  def parse(response, url:, data: {})
    @base_uri = 'https://ng.oraimo.com/oraimo-slice-link-10000mah-12w-fast-charge-3-in-1-portable-power-bank-with-built-in-lightning-type-c-micro-usb-cable.html'
    # response = browser.current_response


    browser.visit(@base_uri)
    response = browser.current_response

    item = {}
    item[:url] = @base_uri
    item[:name] = response.css('.page-title')&.text&.squish
    item[:reviews_count] = response.at_css('.action.view')&.text&.delete('^0-9').to_i
    item[:image_url] = response.css('.gallery-placeholder img').map{ |link| link['src'] }
    # item[:warranty_text] = app.css('.cart-care-box strong')&.text
    item[:warranty_image_url] = response.css('.cart-care-image img').map{ |link| link['src'] }
    item[:old_price] = response.css('.price')[1]&.text&.squish&.delete('^0-9').to_i
    item[:current_price] = response.css('.price')[0]&.text&.squish&.delete('^0-9').to_i
    item[:short_detail] = response.css('.product.attribute.overview .value p').map{ |element| element.inner_html }.join
    item[:long_detail] = response.css('.product.attribute.description .value').map{ |element| element.inner_html }.join
    item[:colors] = response.css(".swatch-option.color").map{ |attr| attr['data-option-tooltip-value'] }
    
    # item[:name] = app.css('.product-item-link')&.text&.squish
    # item[:image_url] = app.css('.product-image-photo').map{ |link| link['src'] }.join
    # item[:old_price] = app.css('.price')[1]&.text&.squish&.delete('^0-9').to_i
    # item[:current_price] = app.css('.price')[0]&.text&.squish&.delete('^0-9').to_i
    # item[:reviews_count] = app.at_css('.action.view')&.text&.delete('^0-9').to_i

    save_to "product_show.json", item, format: :pretty_json, position: false

  end
end

ProductsScraper.crawl!