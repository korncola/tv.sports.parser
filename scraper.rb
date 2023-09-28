#!/usr/bin/env ruby
require 'ferrum'
require 'nokogiri'

def scrape_site
  browser = Ferrum::Browser.new({
    headless: "new",
    host: "localhost",
    port: 6766,
    window_size: [1920,1080]
  })
  browser.cookies.set(name: "user_country_id", value: "202", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "user_country", value: "2", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "lang", value: "2", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "loc_lang", value: "2", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "time_format_12", value: "0", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "user_time_zone", value: "Europe%2FBerlin", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "user_time_zone_id", value: "2", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "mycountries", value: "%2C4%2C5%2C6%2C2%2C101", domain: "sport-tv-guide.live")
  browser.cookies.set(name: "exclude_stations", value: "%7B%22101%22%3A%5B%221952%22%2C%222529%22%2C%222849%22%2C931%5D%2C%222%22%3A%5B711%5D%2C%224%22%3A%5B2813%5D%7D", domain: "sport-tv-guide.live")

  browser.go_to("https://sport-tv-guide.live/de/live/allsports")
  browser.mouse.click(:x => 60, :y => 150)
  y = 0
  40.times do
    y += 200
    #browser.screenshot(path: "screenshots/debug-#{y}.png")
    #browser.mouse.down
    browser.mouse.scroll_to(0, y)
    sleep 1
  end
  browser.body
end

def parse_html(html)
  doc = Nokogiri::HTML(html)
  listings = Array.new
  doc.css('div.listData').xpath('//a[@class="article flag"]').css('div.row').map do |row|
    time = row.xpath('div[@class="main time col-sm-2 hidden-xs"]').css('b').text.strip
    sport = row.xpath('div[@class="main time col-sm-2 hidden-xs"]').xpath('div[@class="typeName col-wrap"]').text.strip
    league = row.xpath('div[@class="col-xs-8 mobile-small fs-13"]').css('b').text.strip
    event = row.xpath('div[@class="col-xs-8 mobile-small fs-13"]').at('div').css('div')[1].text.strip
    stations = row.xpath('div[@class="col-xs-4 mobile-normal text-right p-0"]').css('img').map do |station|
     station["title"]
    end
    listing = Listing.new(time, sport, league, event, stations)
    listings << listing
  end
  listings
end

def print_listings(listings)
  listings.each do |listing|
    puts "#{listing.time} <strong>#{listing.sport} #{listing.league}</strong> #{listing.event} @ #{listing.stations.join('|')}"
  end
end

Listing = Struct.new(:time, :sport, :league, :event, :stations)
html = scrape_site()
listings = parse_html(html)
print_listings(listings)
