class Scrapper
	attr_reader :resultat

	def initialize	
		@resultat = perform
	end

	def save_to_json
		json_syntax = File.open("db/emails.json", "w") do |f| 
			f.write(@resultat.to_json)
		end
	end

	def save_to_g_ss(g_session)
		x = 1 
		y = 1
		# my_ss[y, x]
		my_ss = g_session.create_spreadsheet("test_ss").worksheets[0]
		@resultat.each do |index|
			index.each do |ville, email|
				my_ss[y, x] = ville
				my_ss[y, x + 1] = email
				y += 1
			end
		end
		my_ss.save		
	end

	def save_to_csv
		numero = 1
		my_csv = CSV.open("db/emails.csv", "w") do |csv|
			@resultat.each do |index|
				index.each do |ville, email|
					csv << [ville, email]
					numero += 1
				end
			end
		end
	end

	private

	def open_page(link)
		Nokogiri::HTML(open(link))
	end

	def list_town(html)
		array = []
		html.xpath('//a[contains(@class,"lientxt")]').each do |link|
			str = link['href']
			str = str.gsub './', 'http://annuaire-des-mairies.com/'
			array << str
		end
		return array
	end

	def town_name(html)
		html.xpath('//main/section[1]/div/div/div/h1').text.split[0]
	end

	def town_email(html)
		html.xpath('//main/section[2]/div/table/tbody/tr[4]/td[2]').text
	end

	def perform
		html_95 = open_page("http://annuaire-des-mairies.com/val-d-oise.html")
		list_town(html_95).map do |town|
			print "tic "
			html_town = open_page(town)
			Hash[town_name(html_town), town_email(html_town)]			
		end
	end
end

#my_scrap = Scrapper.new
#pp my_scrap.resultat
