require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'tanakai'
  # gem 'mechanize'
end

require 'tanakai'
# require 'mechanize'

# SlackAppsScraper
class ProductsScraper < Tanakai::Base
  @name = 'slack_spider'
  @engine = :selenium_firefox
  @start_urls = ['https://ng.oraimo.com/oraimo-freepods-lite-40-hour-playtime-enc-true-wireless-earbuds.html']
  @config = { user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
  before_request: { delay: 4..7 } }

  def parse(response, url:, data: {})
    @base_uri = 'https://ng.oraimo.com/oraimo-freepods-lite-40-hour-playtime-enc-true-wireless-earbuds.html'
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

    save_to "tanakai_result.json", item, format: :pretty_json, position: false

  end
end

ProductsScraper.crawl!