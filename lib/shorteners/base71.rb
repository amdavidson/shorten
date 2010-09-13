class Base71
	@@ranges = [
		('0'..'9'),
		('a'..'z'),
		('A'..'Z'),
		('$'..'$'),
		('-'..'.'),
		('_'..'_'),
		('('..')'),
		('*'..'+'),
		('!'..'!')
		]
	@@base = nil
	@@offsets = nil

	def self.to_s(number)
		if @@base.nil?
			@@base = self.calculate_base
		end
		string = ""
		while number > (@@base - 1)
			place = number % @@base
			string = self.lookup(place) + string
			number = number / @@base	
		end

		self.lookup(number) + string
	end

	def self.to_i(string)
		if @@base.nil?
			@@base = self.calculate_base
		end
		number = 0
		i = string.length - 1
		string.each_byte do |c|
			c = c.chr
			@@ranges.each_index do |j|
				range = @@ranges[j]
				if range.member? c
					number += (c[0] - range.to_a.first[0] + @@offsets[j]) * (@@base ** i)
					break
				end
			end
			#if ("0".."9").member? c
			#	number += c.to_i * (@@base ** i)
			#elsif ("a".."z").member? c
			#	first = "a"
			#	number += (c[0] - first[0] + 10) * (@@base ** i)
			#else
			#	first = "A"
			#	number += (c[0] - first[0] + 36) * (@@base ** i)
			#end
			i -= 1
		end
		number
	end

	def self.lookup(place)
		string = ""
		if @@base.nil?
			@@base = self.calculate_base
		end
		(0..(@@ranges.length-1)).each do |i|
			range_array = @@ranges[i].to_a
			start = 0 + @@offsets[i]
			stop = range_array.length - 1 + @@offsets[i]
			if (start..stop).member? place
				string = range_array[place - @@offsets[i]]
				break
			end 
		end
		#if (0..9).member? place
		#	string = "#{place}"
		#elsif (10..35).member? place
		#	string = ("a".."z").to_a[place - 10]
		#else
		#	string = ("A".."Z").to_a[place - 36]
		#end

		string
	end

	def self.next_integer(integer)
		integer + 1
	end

	def self.calculate_base
		i = 0
		@@offsets = []
		@@ranges.each do |range|
			@@offsets << i
			i += range.to_a.length
		end
		i
	end
end