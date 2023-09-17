# TV Sports Parser

## Description
Scrape a public site for live tv sports guide data and pst to a wordpress site

## Requirements
* `ferrum` ruby gem: [source](https://github.com/rubycdp/ferrum)
* `nokogiri` ruby gem: [source](https://github.com/sparklemotion/nokogiri.org/)
* `google chrome`

## Implemantation
* scrapes https://sport-tv-guide.live/live/allsports with a pre set (hardcoded) cookie to set tv stations of countries and use all sports types
* scraping is done via `ferrum`, which uses normal chrome in headless-mode
* data will be put in Listing `Struct`
* outputs to `stdout` in wordpress format, so you can copy-paste

## Weaknesses
* not immune to changes on source sites of course
* cookie is hardcoded
* scrolling to bottom, as source sites uses javascript lazyload, is not reliable, needs improvement
* output needs beautification

## Future Improvements
* icons
* configurable cookie
    * countries
    * sports types
    * tv stations
* source sites offers detail pages for each event with more extensive data, leverage them to get more reliable/detailed data
* auto-post to wordpress
