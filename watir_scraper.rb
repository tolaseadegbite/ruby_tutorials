require 'watir'

browser = Watir::Browser.new :firefox

browser.goto 'https://www.jumia.com.ng/'
browser.link(text: 'Sell on Jumia').click

puts browser.title
# => 'Guides – Watir Project'
browser.close