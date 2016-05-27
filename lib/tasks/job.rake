require 'scraper/mytaganrogcom'
require 'scraper/bloknot-taganrogru'
require 'scraper/161ru'
require 'scraper/rostovliferu'

namespace :job do

  task mytaganrogcom_parse: :environment do
    p 'start'
    Scraper::Mytaganrogcom.parse
    p 'done'
  end

  task bloknottaganrogru_parse: :environment do
    p 'start'
    Scraper::Bloknottaganrogru.parse
    p 'done'
  end

  task ru161_parse: :environment do
    p 'start'
    Scraper::RU161.parse
    p 'done'
  end

  task rostovliferu_parse: :environment do
    p 'start'
    Scraper::Rostovliferu.parse
    p 'done'
  end

  task parse_all: :environment do
    p 'start bloknot-taganrog.ru'
    Scraper::Bloknottaganrogru.parse
    p 'done bloknot-taganrog.ru'

    p 'start mytaganrog.com'
    Scraper::Mytaganrogcom.parse
    p 'done mytaganrog.com'

    p 'start 161.ru'
    Scraper::RU161.parse
    p 'done 161.ru'

    p 'start rostovliferu.ru'
    Scraper::Rostovliferu.parse
    p 'done rostovliferu.ru'
  end
end