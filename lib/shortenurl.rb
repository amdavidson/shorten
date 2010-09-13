class ShortenUrl < Sequel::Model
	unless table_exists?
		set_schema do
			primary_key :id
			String :key
			String :url
			Time :time
		end
		create_table
	end
			
	def short_url
		"#{Shorten.base_url}#{Shorten.shortener.to_s(id)}"
	end
	
	def self.create_url(link)
		uri = URI::parse(link)
		raise "Invalid URL" unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS

		url = self.filter(:url => link).first
		if !url
			max_id = self.order(:id.desc).first
			if !max_id
				max_id = 0
			else
				max_id = max_id.id
			end
			url = self.new(:url => link)
			url.save
		end
		
		url
	end
end
