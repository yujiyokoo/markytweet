require 'tweet_generator'
MarkyTweet.controllers :next_tweet do
  layout :app
  get :create do
    if !params[:hpot].nil? && !params[:hpot].empty?
      @generated_tweet = 'Please leave the text field empty where indicated.'
    else
      @generated_tweet = TweetGenerator.generate( params[:query] )
    end
    render 'next_tweet/create'
  end
end
