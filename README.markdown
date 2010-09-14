# Shorten

Shorten is an extremely simple Sinatra based URL shortener. There is almost no UI and only the most 
basic of functionality.

You can see an example of this service running at [&#x27bc;.ws][example]. 

## Installation

### Clone
	
	$ git clone git://github.com/amdavidson/shorten.git
	
### Install required gems
	
	$ gem install rack sinatra sequel anybase pg
	
Optional: Install the [Heroku][heroku] gem if you want to deploy on Heroku.
	
	$ gem install heroku
	
### Configure

Open <code>main.rb</code> in your favorite editor and change this block: 
	Shorten = OpenStruct.new(
		:base_url => "http://xn--8gi.ws/",
		:service_name => "&#x27bc;.ws",
		:button_text => "&#x27bc;",
		:path_size => 4
	)

### Deploy

In the application directory run the following commands

	$ heroku create
	$ git push heroku master
	
### Enjoy

You now have your own running URL shortener. Now use [domai.nr][domainr] or [name.com][name] to find 
yourself an available, short URL and reconfigure <code>main.rb</code>
	
	
## History 

This is a fork of the original [Shorten][orig_url] application created by [Andrew Pilsch][author]. 
I made some updates to randomize the shortened URL in the style of [bit.ly][bitly] and 
[tr.im][trim]. I have also modified the software to be easy to deploy to Heroku.






[orig_url]: http://blog.pilsch.com/past/2009/6/7/shorten_your_own_damn_urls/
[author]: http://andrew.pilsch.com/
[example]: http://xn--8gi.ws
[bitly]: http://bit.ly
[trim]: http://tr.im
[heroku]: http://heroku.com
[domainr]: http://domai.nr
[name]: http://name.com