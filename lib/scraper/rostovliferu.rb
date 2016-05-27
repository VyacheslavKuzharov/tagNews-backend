require 'scraper'

module Scraper
  module Rostovliferu

    def self.parse
      site = Site.find_by_name 'rostovlife.ru'
      if Scraper.site_content_available?("#{site.url}nenovosti/posts", container_main_div: 'article.b-content')
        I18n.locale = :ru
        region = Region.find_by_name I18n.t('regions.rostov_region')
        last_date = site.news.last_date
        count_pages = Scraper.get_links("#{site.url}nenovosti/posts", container_p_link: 'article.b-content div.b-content__main div.b-pagination a:last')
        is_break = false
        count_pages.times do |i|
          links = Scraper.get_links("#{site.url}/nenovosti/posts?page=#{i+1}", container_link: 'article.b-content div.b-content__main article.n-grid__column a')
          links.each do |link|
            string_href = link.attr('href')

            info = Scraper.load_news("#{site.url}#{string_href}", site.url, container_title: 'article.b-content h1.b-title', container_image: 'div.n-post-plate__pic2 span.img', container_date: 'article.b-content small.n-post-plate__panel__date', container_description: 'article.b-content section.n-post div.n-post__text')
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