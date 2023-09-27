# TV Sports Parser

## Description
Scrape a public site for live tv sports guide data and post to a wordpress site

## Requirements
* `ferrum` ruby gem: [source](https://github.com/rubycdp/ferrum)
* `nokogiri` ruby gem: [source](https://github.com/sparklemotion/nokogiri.org/)
* `google chrome`

## Implementation
* scrapes https://sport-tv-guide.live/live/allsports with pre set (hardcoded) cookies to set tv stations of countries and use all sports types
* scraping is done via `ferrum`, which uses normal chrome in new headless-mode, [debugging possible](https://developer.chrome.com/articles/new-headless/#debugging)
* data will be put in Listing `Struct`
* outputs to `stdout` in wordpress format, so you can copy-paste

## Weaknesses
* not immune to changes on source sites of course
* cookie is hardcoded

## Future Improvements
* icons
* configurable cookie (or at least document)
    * countries
    * sports types
    * tv stations
* source sites offers detail pages for each event with more extensive data, leverage them to get more reliable/detailed data
* auto-post to wordpress
