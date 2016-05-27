# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

I18n.locale = :ru

regions = [
    'Ростовская область',
    'Краснодарский край'
]

regions.each do |region|
  Region.create(name: region)
end

rostov_region = Region.find_by_name I18n.t('regions.rostov_region')
krasnodar_region = Region.find_by_name I18n.t('regions.krasnodar_region')

cities = [
    { name: 'Таганрог', region_id: rostov_region.id},
    { name: 'Ростов', region_id: rostov_region.id},
    { name: 'Краснодар', region_id: krasnodar_region.id}
]


cities.each do |city|
  City.create(city)
end

sites = [
    { name: 'mytaganrog.com', url: 'http://mytaganrog.com/' },
    { name: 'bloknot-taganrog.ru', url: 'http://bloknot-taganrog.ru' },
    { name: '161.ru', url: 'http://161.ru/' },
    { name: 'rostovlife.ru', url: 'http://rostovlife.ru/' }
]

sites.each do |site|
  Site.create(site)
end