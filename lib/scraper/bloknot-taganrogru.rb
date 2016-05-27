require 'scraper'

module Scraper
  module Bloknottaganrogru

    def self.parse
      site = Site.find_by_name 'bloknot-taganrog.ru'
      if Scraper.site_content_available?(site.url, container_main_div: 'div.content')
        I18n.locale = :ru
        region = Region.find_by_name I18n.t('regions.rostov_region')
        last_date = site.news.last_date
        count_pages = Scraper.get_links(site.url, container_p_link: 'div.content div.holder div.navigation div.navigation-pages a:last')
        is_break = false
        count_pages.times do |i|
          links = Scraper.get_links("#{site.url}/?PAGEN_1=#{i+1}", container_link: 'div.content div.holder ul.bigline li a.sys')
          links.each do |link|
            string_href = link.attr('href')
            info = Scraper.load_news("#{site.url}#{string_href}", site.url, container_title: 'div.content div.news-detail h1', container_image: 'div.content div.news-detail div.news-picture a img', container_date: 'div.content div.news-detail div.news-item-info span.news-date-time', container_description: 'div.content div.news-detail div.news-text')
            info[:news][:site_id] = site.id
            info[:news][:region_id] = region.id

            if info[:news][:date].include?('минут назад') || info[:news][:date].include?('минуты назад') || info[:news][:date].include?('минуту назад')
              info[:news][:date] = DateTime.now
            elsif info[:news][:date].include?('сегодня')
              str = info[:news][:date].split(',')
              time = str[1]
              today = Date.today
              date = today.to_s + time
              date.to_datetime
            elsif info[:news][:date].include?('вчера')
              info[:news][:date] = DateTime.now - 1.day
            else
              info[:news][:date] = info[:news][:date].to_datetime
            end

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