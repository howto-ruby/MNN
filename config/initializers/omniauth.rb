# Rails.application.config.middleware.use OmniAuth::Builder do
#   # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
#   require 'openid/store/filesystem'
#   
#   provider :twitter, ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET"]
#   provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
#   provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
#   # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {access_type: 'online', approval_prompt: ''}
# 
#   # openid
#   # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'
#   # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
#   # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'aol', :identifier => 'openid.aol.com'
#   # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'myopenid', :identifier => 'myopenid.com'
#   
#   # Sign-up urls for Facebook, Twitter, Github, Google
#   # https://developers.facebook.com/setup
#   # https://github.com/account/applications/new
#   # https://developer.twitter.com/apps/new
#   # https://code.google.com/apis/console/
# end
# 
# # Source: http://www.communityguides.eu/articles/16