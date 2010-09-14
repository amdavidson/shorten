require 'rubygems'
require 'sinatra'
require 'sequel'
require 'uri'

configure do
	Sequel::Model.plugin(:schema)
	
	Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://shorten.db')

	require 'ostruct'
	Shorten = OpenStruct.new(
		:base_url => "http://xn--8gi.ws/",
		:service_name => "&#x27bc;.ws",
		:button_text => "&#x27bc;",
		:path_size => 4
	)
	
	$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
	
	# Change these two references from "62" to "71" if you want to include
	# URL-legal, non-alphanumeric characters in your URLs.
	require "shorteners/base62"
	Shorten.shortener = Base62
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')

require 'shortenurl'

helpers do
	def show_information
		erb :information, :layout => false
	end

	def validate_link(link)
		halt 401, 'We do not accept local URLs to be shortened' unless valid_url? link
	end
	
	# Determine if a URL is valid.  We run it through 
	def valid_url?(url)
		if url.include? "%3A"
			url = URI.unescape(url)
		end

		retval = true
		
		begin
			uri = URI.parse(URI.escape(url))
			if uri.class != URI::HTTP
				retval = false
			end
			
			host = (URI.split(url))[2]
			if host =~ /^(localhost|192\.168\.\d{1,3}\.\d{1,3}|127\.0\.0\.1|172\.((1[6-9])|(2[0-9])|(3[0-1])).\d{1,3}\.\d{1,3}|10.\d{1,3}\.\d{1,3}.\d{1,3})/
				retval = false
			end
		rescue URI::InvalidURIError
				retval = false
		end
		
		retval
	end
end 

get '/' do
	@information = show_information
	erb :index, :locals => { :type => "main" }
end

get '/new' do
	@information = show_information
	erb :new, :locals => { :type => "main" }
end

get %r(/(api-){0,1}create/(.*)) do |api, link|
	#link = params[:link]
	validate_link link

	url = ShortenUrl.create_url(link)

	if api == "api-"
		"#{url.short_url}"
	else
		erb :finished, :locals => { :url => url, :type => "finished" }
	end
end

get %r(/(api-){0,1}create) do |api|
	if request['url']
		validate_link request['url']
		url = ShortenUrl.create_url(request['url'])
		if api == "api-"
			"#{url.short_url}"
		else
			erb :finished, :locals => { :url => url, :type => "finished" }
		end
	end
end

post '/' do
	validate_link params[:url]

	url = ShortenUrl.create_url(params[:url])
	
	#"#{url.short_url}"
	erb :finished, :locals => { :url => url, :type => "finished" }
end

get '/:short' do
	url = ShortenUrl.filter(:id => Shorten.shortener.to_i(params[:short])).first
	
# 	require 'log'
# 	
# 	log = Log.new
# 	log.ip = request.ip
# 	log.time = Time.now
# 	log.shorten_url_id = url.id
# 	log.save
	
	halt 404, "Page not found" unless url
	redirect url.url
end
