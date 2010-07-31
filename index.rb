require 'rubygems'
require 'sinatra'
require 'oauth'
require 'grackle'
require 'erb'

enable :sessions

CONSUMER_KEY = 'QhV4TkQXmvobR8AitgM3DQ'
CONSUMER_SECRET = 'G1VaU1zJpWsENw00ucJQoI9vF0lUObEQgmQwNGqUQA'
CALLBACK_URL = 'http://cyyen.mit.edu/oleana/auth'

get '/connect' do
  # consumer_key and consumer_secret are from Twitter.
  # You'll get them on your application details page.
  @consumer = get_consumer

  # Ask for a token to make a request
  url = "http://cyyen.mit.edu/oleana/auth"
  request_token = @consumer.get_request_token(:oauth_callback => url)

  # Take a note of the token and the secret. You'll need these later
  session[:token] = request_token.token
  session[:token_secret] = request_token.secret

  # Send the user to Twitter to be authenticated
  redirect request_token.authorize_url
end


get '/auth' do
  @consumer = get_consumer

  # Your callback URL will now get a request that contains an 
  # oauth_verifier. Use this and the request token from earlier to 
  # construct an access request.
  request_token = OAuth::RequestToken.new(@consumer, session[:token],
                                          session[:token_secret])

  access_token = @consumer.get_access_token(request_token, :oauth_verifier => params[:oauth_verifier])

  session[:token] = access_token.token
  session[:token_secret] = access_token.secret

  # Get account details from Twitter
  response = @consumer.request(:get, '/account/verify_credentials.json',
                               access_token, { :scheme => :query_string })
  redirect 'list'
end


def get_consumer
  return OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
                             { :site => 'http://twitter.com',
                               :request_token_path => '/oauth/request_token',
                               :access_token_path => '/oauth/access_token',
                               :authorize_path => '/oauth/authorize' })
end


def get_client
  return Grackle::Client.new(:auth => {
    :type => :oauth,
    :consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET,
    :token => session[:token], :token_secret => session[:token_secret] })
end


get '/list' do
  @client = get_client
  erb :list
end


get '/hi' do
  erb :index
end





