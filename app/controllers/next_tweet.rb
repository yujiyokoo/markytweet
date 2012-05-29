require 'tweet_generator'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

MarkyTweet.controllers :next_tweet do
  layout :app
  get_or_post :create, :provides => [ :html, :json ] do
    if( params[:search_results] && !params[:search_results].empty? )
      @generated_tweet = TweetGenerator.generate_from_results(
        params[:search_results]
      )
    elsif !params[:hpot].nil? && !params[:hpot].empty?
      @generated_tweet = 'Please leave the text field empty where indicated.'
    else
      @generated_tweet = TweetGenerator.generate( params[:query] )
    end
    case content_type
      when  :json
        return { :output => @generated_tweet }.to_json
      when  :html
        render 'next_tweet/create'
    end
  end
end
