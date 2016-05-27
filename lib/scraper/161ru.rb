require 'scraper'

module Scraper
  module RU161

    def self.parse
      site = Site.find_by_name '161.ru'
      if Scraper.site_content_available?("#{site.url}text/newsline/?gm", container_main_div: 'div.content_block')
        I18n.locale = :ru
        region = Region.find_by_name I18n.t('regions.rostov_region')
        last_date = site.news.last_date
        count_pages = Scraper.get_links("#{site.url}text/newsline/?gm", container_p_link: 'div.content_block td.col_center div.pager a:last')
        is_break = false
        count_pages.times do |i|
          links = Scraper.get_links("#{site.url}text/newsline?p=#{i+1}", container_link: 'div.content_block td.col_center div.news-record div.news-block-left a[href^="/text/newsline/"]')
          links.each do |link|
            string_href = link.attr('href')

            info = Scraper.load_news("#{site.url}#{string_href}", site.url, container_title: 'div.content_block td.col_center div.news-record div.news-block-left span.title2', container_image: 'div.content_block td.col_center div.news-record div.news-block-justify img', container_date: 'div.content_block td.col_center div.news-record div.news-block-left span.title', container_description: 'div.content_block td.col_center div.news-record div.news-block-justify')
            info[:news][:site_id] = site.id
            info[:news][:region_id] = region.id
            info[:news][:date] =  Scraper.get_date161(info[:news][:date])


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