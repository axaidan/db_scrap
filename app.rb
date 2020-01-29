require 'bundler'
Bundler.require
require 'open-uri'

require_relative 'lib/app/scrapper'

session = GoogleDrive::Session.from_config("config.json")

my_scrap = Scrapper.new

#JSON
my_scrap.save_to_json

#GOOGLE TA MERE
my_scrap.save_to_g_ss(session)

#CSV
my_scrap.save_to_csv
puts my_scrap.resultat
