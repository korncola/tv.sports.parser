#!/usr/bin/env ruby
require 'ferrum'
require 'nokogiri'


def scrape_site
  cookie = "not_checked_settings=1; user_country_id=202; user_country=2; date_format_short=%25e+%25b; sportsorder=1%2C18%2C15%2C29%2C7%2C8%2C14%2C39%2C40%2C13%2C21%2C10%2C4%2C17%2C27%2C51%2C22%2C28%2C37%2C19%2C5%2C44%2C53%2C26%2C25%2C56%2C12%2C54%2C35%2C50%2C16%2C43%2C32%2C47%2C42%2C36%2C33%2C6%2C20%2C55%2C45%2C38%2C34%2C24%2C46%2C52%2C31%2C30%2C48%2C9%2C57%2C49%2C11%2C41; sportsorderrev=41%2C11%2C49%2C57%2C9%2C48%2C30%2C31%2C52%2C46%2C24%2C34%2C38%2C45%2C55%2C20%2C6%2C33%2C36%2C42%2C47%2C32%2C43%2C16%2C50%2C35%2C54%2C12%2C56%2C25%2C26%2C53%2C44%2C5%2C19%2C37%2C28%2C22%2C51%2C27%2C17%2C4%2C10%2C21%2C13%2C40%2C39%2C14%2C8%2C7%2C29%2C15%2C18%2C1; show_college=1; show_woman=1; time_format_12=0; user_time_zone=Europe%2FBerlin; user_time_zone_id=2; mycountriesorder=2%2C15; lang=1; loc_lang=1; date_format=d.m.Y; myleagues=1%2C10%2C39%2C67%2C18%2C17%2C48%2C2%2C19%2C3; mysports=1%2C18%2C15%2C29%2C7%2C8%2C14%2C39%2C40%2C13%2C21%2C10%2C4%2C17%2C27%2C19%2C35%2C32%2C52%2C11; mysports7=1%2C18%2C15%2C29%2C8%2C14%2C39%2C13%2C21%2C10%2C4%2C17%2C27%2C19%2C35%2C32%2C52%2C11; mysports40=1%2C18%2C15%2C29%2C8%2C14%2C39%2C13%2C21%2C10%2C4%2C17%2C27%2C19%2C35%2C32%2C52%2C11; myteams=2464%2C3%2C4%2C2249%2C2607%2C3923%2C3917%2C2468%2C2250%2C2454%2C2247%2C6%2C155%2C102%2C94%2C1961%2C20922; search_type=3; exclude_stations=%7B%22101%22%3A%5B%221952%22%2C%222529%22%2C%222849%22%5D%2C%222%22%3A%5B711%5D%2C%224%22%3A%5B2813%5D%7D; mycountries=%2C4%2C5%2C6%2C2%2C18%2C10%2C76%2C101%2C33; visitedleagues=4%2C2%2C10; s_sessions=0j6tl87m7i8a4n9sk0p4m1nvcfl0vcdp; myid=f02dd32761828f0cb7f"
  browser = Ferrum::Browser.new
  browser.headers.add({"Cookie" => cookie})
  browser.go_to("https://sport-tv-guide.live/live/allsports")
  y = 0
  10.times do
    y += 1000
    browser.screenshot(path: "google-#{y}.png")
    browser.mouse.scroll_to(0, y)
  end
  html = browser.body
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
  browser.quit
  listings
end

def print_wordpress(listings)
  listings.each do |listing|
    puts "#{listing.time} <strong>#{listing.sport} #{listing.league}</strong> #{listing.event} @ #{listing.stations.join('|')}"
  end
end

Listing = Struct.new(:time, :sport, :league, :event, :stations)
listings = scrape_site()
print_wordpress(listings)