require 'rubygems'
require 'sinatra'
require 'sequel'
require 'uri'




configure do
	Sequel::Model.plugin(:schema)

  keys = YAML.load(File.open("keys.yaml", "r").read)	
	Sequel.connect(keys['database_url'] || 'sqlite://shorten.db')

	require 'ostruct'
	Shorten = OpenStruct.new(
		:base_url => "http://amd.im/",
		:service_name => "amd.im",
		:button_text => "shorten",
		:path_size => 4
	)
	
	$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
	
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
	erb :index
end

get '/new' do
	@information = show_information
	erb :new, :locals => { :type => "main" }
end

get %r(/(api-){0,1}create/(.*)) do |api, link|
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

	url = ShortenUrl.create_url(params[:url], params[:image])
	
	erb :finished, :locals => { :url => url, :type => "finished", :image => params[:image] }
end

get '/upload' do 
  
  erb :upload
  
end

post '/upload' do 
  require 'aws/s3'
  require 'yaml'
 
  keys = YAML.load(File.open("keys.yaml", "r").read)
 
  # establish connection
  AWS::S3::Base.establish_connection!(
    :access_key_id => keys['s3_key'],
    :secret_access_key => keys['s3_secret']
  )
  
  # generate key and check uniqueness
  key = Anybase::Base62.random(Shorten.path_size)
	key_check = ShortenUrl.filter(:url => key).first
	
	while key_check
		key = Anybase::Base62.random(Shorten.path_size)
		key_check = ShortenUrl.filter(:url => key).first
	end
	
	# merge key and extension
	ext = File.extname(params[:file][:filename])
  filename = key + ext
  #filename = params[:file][:filename]
  
  # upload to S3
  AWS::S3::S3Object.store(filename, open(params[:file][:tempfile]), keys["s3_bucket"], :access => :public_read)
  object_url = AWS::S3::S3Object.url_for(filename, keys["s3_bucket"], :authenticated => false)
  
  # generate shorturl
  url = ShortenUrl.new(:url => object_url, :key => key, :image => params[:image])
  url.save
  #url = ShortenUrl.create_url(object_url, params[:image])
  
  erb :finished, :locals => { :url => url, :type => "finished", :image => params[:image] }
end 

get '/:short' do

	url = ShortenUrl.find(:key => params[:short])
	
	halt 404, "Page not found" unless url
	
	if url.image == true 
	  erb :image, :locals => {:url => url.url}
	else
	  redirect url.url
	end

end



