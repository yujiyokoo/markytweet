require 'tweet_generator'
MarkyTweet.controllers :next_tweet do
  layout :app
  get :create do
    @generated_tweet = TweetGenerator.generate( params[:query] )
    render 'next_tweet/create'
  end
end
