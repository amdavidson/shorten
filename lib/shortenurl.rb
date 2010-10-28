require 'anybase'

class ShortenUrl < Sequel::Model
	plugin :validation_helpers
	unless table_exists?
		set_schema do
			primary_key :id
			String :key
			String :url
			Boolean :image
			Time :time
		end
		create_table
	end
	
	def validate
		super
		validates_presence [:url, :key]
		validates_unique :url
		validates_unique :key
	end
			
	def short_url
		"#{Shorten.base_url}#{self.key.to_s}"
	end
	
	def self.create_url(link, image = false)
 		uri = URI::parse(link)
 		raise "Invalid URL" unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS

		url = self.filter(:url => link).first
		if !url 

			key = Anybase::Base62.random(Shorten.path_size)
			key_check = self.filter(:url => key).first
			
			while key_check
				key = Anybase::Base62.random(Shorten.path_size)
				key_check = self.filter(:url => key).first
			end
	
			url = self.new(:url => link, :key => key, :image => image)
			url.save					
		end
		
		url
	end
end
