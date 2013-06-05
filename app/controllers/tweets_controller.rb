class TweetsController < ApplicationController
  before_filyer :init

  def init(access_token,access_token_secret)
    @client = Twitter::Client.new(
      :oauth_token => access_token,
      :oauth_token_secret => access_token_secret
      )
  end
  
end
