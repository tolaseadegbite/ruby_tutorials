require 'nokogiri'
require 'watir'
require 'json'

browser = Watir::Browser.new :firefox, headless: true

browser.goto 'https://ng.oraimo.com/oraimo-freepods-lite-40-hour-playtime-enc-true-wireless-earbuds.html'

doc = Nokogiri::HTML.parse(browser.html)

base_uri = 'https://ng.oraimo.com/oraimo-freepods-lite-40-hour-playtime-enc-true-wireless-earbuds.html#'

item = {}
item[:url] = base_uri
item[:name] = doc.css('.page-title')&.text&.strip
item[:reviews_count] = doc.at_css('.action.view')&.text&.delete('^0-9').to_i
item[:image_url] = doc.css('.gallery-placeholder img').map{ |link| link['src'] }[0]
# item[:image_url] = doc.css('.gallery-placeholder img').map{ |link| link['src'] }
item[:warranty_image_url] = doc.css('.cart-care-image img').map{ |link| link['src'] }
item[:old_price] = doc.css('.price')[1]&.text&.delete('^0-9').to_i
item[:current_price] = doc.css('.price')[0]&.text&.delete('^0-9').to_i
item[:short_detail] = doc.css('.product.attribute.overview .value p').map{ |element| element.inner_html }.join
item[:long_detail] = doc.css('.product.attribute.description .value').map{ |element| element.inner_html }.join
item[:colors] = doc.css('.swatch-option.color').map{ |attr| attr['data-option-tooltip-value'] }

# item[:name] = app.css('.product-item-link')&.text&.squish
# item[:image_url] = app.css('.product-image-photo').map{ |link| link['src'] }.join
# item[:old_price] = app.css('.price')[1]&.text&.squish&.delete('^0-9').to_i
# item[:current_price] = app.css('.price')[0]&.text&.squish&.delete('^0-9').to_i
# item[:reviews_count] = app.at_css('.action.view')&.text&.delete('^0-9').to_i

# save_to "product_2_show.json", item, format: :pretty_json, position: false

File.open("./watir_result.json","w") do |f|
  f.write(JSON.pretty_generate(item))
end

# puts item

browser.close