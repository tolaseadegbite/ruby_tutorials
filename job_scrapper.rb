require 'bundler/inline'
require 'mechanize'
require 'logger'
require 'tanakai'

gemfile do
  source 'https://rubygems.org'
  gem 'tanakai'
end

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

class JobScraper < Tanakai::Base
  @name= 'eng_job_scraper'
  @start_urls = ["https://www.indeed.com/jobs?q=software+engineer&l=New+York%2C+NY"]
  @engine = :mechanize

  @@jobs = []

  def scrape_page
    doc = browser.current_response
    returned_jobs = doc.css('td#resultsCol')
    returned_jobs.css('div.job_seen_beacon').each do |char_element|
      # scraping individual listings
      title = char_element.css('h2.jobTitle > a > span').text.gsub(/\n/, "")
      link = "https://indeed.com" + char_element.css('h2.jobTitle > a').attributes["href"].value.gsub(/\n/, "")
      description = char_element.css('div.job-snippet').text.gsub(/\n/, "")
      company = char_element.css('div.companyInfo > span.companyName').text.gsub(/\n/, "")
      location = char_element.css('div.companyInfo > div.companyLocation').text.gsub(/\n/, "")
      salary = char_element.css('span.estimated-salary > span').text.gsub(/\n/, "")

      # creating a job object
      job = {title: title, link: link, description: description, company: company, location: location, salary: salary}

      # adding the object if it is unique
      @@jobs << job if !@@jobs.include?(job)
    end
  end

  def parse(response, url:, data: {})
    # scrape first page
    scrape_page

    # next page link starts with 20 so the counter will be initially set to 2
    num = 2

    #visit next page and scrape it
    10.times do
        browser.visit("https://www.indeed.com/jobs?q=software+engineer&l=New+York,+NY&start=#{num}0")
        scrape_page
        num += 1
    end

    @@jobs

    CSV.open('jobs.csv', "w") do |csv|
        csv << @@jobs
    end
  end
end

JobScraper.crawl!