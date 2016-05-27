require 'scraper'

module Scraper
  module Mytaganrogcom

    def self.parse
      site = Site.find_by_name 'mytaganrog.com'
      if Scraper.site_content_available?(site.url, container_main_div: 'div#main-wrapper')
        I18n.locale = :ru
        region = Region.find_by_name I18n.t('regions.rostov_region')
        last_date = site.news.last_date
        count_pages = Scraper.get_links(site.url, container_p_link: "div#main-wrapper div#main-content div.item-list ul.pager li.pager-last a")
        is_break = false
        count_pages.times do |i|

          links = Scraper.get_links("#{site.url}/node?page=#{i == 0 ? 0 : i}", container_link: 'div#main-content div.block-content div.article h2.node-title a')
          links.each do |link|
            string_href = link.attr('href')
            info = Scraper.load_news("#{site.url}#{string_href}", site.url, container_title: 'div#main-wrapper div#main-content h1#page-title', container_image: 'div#main-content div.region-content div#block-system-main div.field-items p.rtecenter img', container_date: 'div#main-content div.footer span.pubdate', container_description: 'div#main-content div.region-content div#block-system-main div.field-items div.field-item p')
            info[:news][:site_id] = site.id
            info[:news][:region_id] = region.id
            info[:news][:date] = info[:news][:date].to_datetime

            if info[:news][:date] > last_date
              Scraper.save_news(info[:news], info[:photo])
            else
              is_break = true
              break
            end
          end
          break if is_break
        end
      end
    end
  end
end
