require 'nokogiri'
require 'watir'
require 'json'

browser = Watir::Browser.new :firefox

browser.goto 'https://ng.oraimo.com/oraimo-freepods-lite-40-hour-playtime-enc-true-wireless-earbuds.html#'

browser.link(text: 'CUSTOMER REVIEWS').click

# doc = Nokogiri::HTML.parse(browser.html)

browser.close