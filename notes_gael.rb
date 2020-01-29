# frozen_string_literal: true

require 'nokogiri'
require 'restclient'

class CityHall
  attr_reader :town

  def initialize
    @town = departement
  end

  private

  def open_page(link)
    Nokogiri::HTML(RestClient.get(link))
  end

  def list_town(html)
    html.xpath('//tr/td/p/a/@href').map(&:text).map { |node| node.gsub './', 'http://annuaire-des-mairies.com/' }
  end

  def town_name(html)
    html.xpath('//main/section[1]/div/div/div/h1').text.split[0]
  end

  def town_email(html)
    html.xpath('//main/section[2]/div/table/tbody/tr[4]/td[2]').text
  end

  def departement
    html = open_page('http://annuaire-des-mairies.com/val-d-oise.html')
    list_town(html).map do |town|
      html = open_page(town)
      Hash[town_name(html), town_email(html)]
    end
  end
end

mairies = CityHall.new
# pp mairies.town
