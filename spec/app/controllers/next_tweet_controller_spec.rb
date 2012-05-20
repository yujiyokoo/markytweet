require 'spec_helper'

describe "NextTweetController" do
  context "when query empty" do
    before(:each) do
      get '/next_tweet/create', :query => ''
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should say query should not be empty" do
      @doc.css( 'p' ).text.should match( /please.*provide.*keyword/i )
    end
    it "should display form" do
      @doc.css( 'form[method=get]' ).should_not be_empty
    end
  end
  context "when honey pot text is not empty" do
    before(:each) do
      get '/next_tweet/create', :query => 'abc', :hpot => 'trapped!'
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should ask user to leave the text field empty" do
      @doc.css( 'p' ).text.should match( /please.*leave.*empty/i )
    end
  end
  context "when it cannot find enough search results" do
    before(:each) do
      get '/next_tweet/create', :query => 'asorecas'
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should say it cannot find out enough about it" do
      @doc.css( 'p' ).text.should match( /sorry.*cannot.*find.*enough.*/i )
    end
  end
  context "when it is successful" do
    before(:each) do
      get '/next_tweet/create', :query => 'postsomething'
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should display a bit of output text for the input" do
      @doc.css( 'p' ).text.should match( /\w+/i )
    end
    it "should display form" do
      @doc.css( 'form[method=get]' ).should_not be_empty
    end
  end
  context "when it encounters error" do
    before(:each) do
      TwitterProxy.should_receive( :search ).and_return( :error => 'ERROR! ERROR!' )
      get '/next_tweet/create', :query => 'error'
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should say error" do
      @doc.css( 'p' ).text.should match( /.*error.*/i )
    end
  end
end
