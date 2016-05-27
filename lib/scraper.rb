require 'mechanize'

module Scraper

  def self.site_content_available?(url, options = {})
    agent = Mechanize.new
    begin
      page = agent.get(url)
    rescue Mechanize::ResponseCodeError => e
      return e
    end
    if page.nil?
      p '-page = nil; ResponseCodeError?-'
      false
    elsif page.search(options[:container_main_div]).empty?
      p '-div content is empty-'
      false
    else
      true
    end
  end

  def self.get_links(url, options = {})
    agent = Mechanize.new
    page = agent.get(url)
    if options[:container_link]
      page.search(options[:container_link])
    else
      str = page.at(options[:container_p_link]).attr('href')
      str.scan(/\d+/).last.to_i rescue 1
    end
  end


  def self.load_news(url, domain, options = {})
    agent = Mechanize.new
    page = agent.get(url)
    info = {}
    info[:news] = {}
    info[:photo] = {}

    info[:news][:title] = page.search(options[:container_title]).text.strip
    info[:news][:date] = page.search(options[:container_date]).text.strip
    info[:news][:description] = page.search(options[:container_description]).text.strip.delete("\r").delete("\n").delete("\t")
    info[:news][:city_id] = Scraper.get_city_id(info[:news][:title])

    image_node = page.search(options[:container_image])

    if !image_node.blank? && !image_node.attr('class').nil? && image_node.attr('class').value  == 'img'
      span_img = image_node.attr('style').value
      info[:news][:remote_image_url] = span_img.slice!(/http.*jpg/)
      info[:photo][:remote_photo_url] = [info[:news][:remote_image_url]]
    elsif !image_node.blank?
      info[:news][:remote_image_url] = Scraper.get_image_url(image_node.attr('src').value, domain)

      nodes = page.search(options[:container_image])
      info[:photo][:remote_photo_url] = []
      nodes.each do |node|
        link = Scraper.get_image_url(node.attr('src'), domain)
        info[:photo][:remote_photo_url] << link
        info[:photo]
      end
    end

    info
  end

  def self.get_image_url(str, domain)
    ary = str.split('/')
    if ary[0] == ''
      return domain + str
    else
      return str
    end
  end

  def self.save_news(news, photos)
    record = News.create(news)

    if !photos[:remote_photo_url].nil?
      photos[:remote_photo_url].each do |photo|
        record.photos.create(remote_photo_url: photo)
      end
    end
    p "record: #{news[:title]}, is saved..."
    unless news[:match].nil?
      p "record: #{news[:title]}, match with #{News.find_by_id(news[:match]).title}"
    end
  end

  def self.get_city_id str
    if str.match(/ростовская/i) || str.match(/ростовскую/i) || str.match(/ростовской/i) || str.match(/таганрогская/i) || str.match(/таганрогскую/i) || str.match(/таганрогской/i) || str.match(/таганрогом/i) || str.match(/ростовом/i)
      return nil
    elsif match_data = (str.match(/ростов/i) || str.match(/таганрог/i))
      city = City.find_by_name(match_data.to_s)
      return city.id
    end
  end


  def self.get_date str
    ary = str.split(' ')
    day = ary.delete_at(0)
    month = ary.delete_at(1)

    case day
      when 'Понедельник,'
        new_day = 'Monday,'
      when 'Вторник,'
        new_day = 'Tuesday'
      when 'Среда,'
        new_day = 'Thusday'
      when 'Четверг,'
        new_day = 'Saturday'
      when 'Пятница,'
        new_day = 'Friday'
      when 'Суббота,'
        new_day = 'Saturday'
      when 'Воскресение,'
        new_day = 'Sunday'
    end

    case month
      when 'Января'
        new_month = 'January'
      when 'Февраля'
        new_month = 'February'
      when 'Марта'
        new_month = 'Mart'
      when 'Апреля'
        new_month = 'April'
      when 'Мая'
        new_month = 'May'
      when 'Июня'
        new_month = 'June'
      when 'Июля'
        new_month = 'July'
      when 'Августа'
        new_month = 'August'
      when 'Сентября'
        new_month = 'September'
      when 'Октября'
        new_month = 'October'
      when 'Ноября'
        new_month = 'November'
      when 'Декабря'
        new_month = 'December'
    end
    ary.insert(0, new_day)
    ary.insert(2, new_month)
    date = ary.join(' ').to_datetime
    date
  end
  def self.get_date161 str
    ary = str.split(' ')
    month = ary.delete_at(1)

    case month
      when 'января'
        new_month = 'January'
      when 'февраля'
        new_month = 'February'
      when 'марта'
        new_month = 'Mart'
      when 'апреля'
        new_month = 'April'
      when 'мая'
        new_month = 'May'
      when 'июня'
        new_month = 'June'
      when 'июля'
        new_month = 'July'
      when 'августа'
        new_month = 'August'
      when 'сентября'
        new_month = 'September'
      when 'октября'
        new_month = 'October'
      when 'ноября'
        new_month = 'November'
      when 'декабря'
        new_month = 'December'
    end
    ary.insert(1, new_month)
    date = ary.join(' ').to_datetime
    date
  end
end