class Log < Sequel::Model
	unless table_exists?
		set_schema do
			primary_key :id
			Integer :shorten_url_id
			String :ip
			String :coordinates
			Time :time
		end
		create_table
	end
end