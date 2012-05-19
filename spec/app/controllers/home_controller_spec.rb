require 'spec_helper'

describe "HomeController" do
  include Capybara::DSL

  before do
    get "/"
  end

  it "should prompt user to enter stuff" do
    last_response.body.should match( /Enter a keyword/i )
  end

  context "in the front page form" do
    before(:each) do
      @doc = Nokogiri::HTML.parse( last_response.body )
    end
    it "should display a form" do
      @doc.css( 'form[method=get]' ).should_not be_empty
    end
    it "should display a text field" do
      @doc.css( 'form input[type=text]' ).should_not be_empty
    end
    it "should display a submit button" do
      @doc.css( 'form input[type=submit]' ).should_not be_empty
    end
    it "should post to next_tweet create action" do
      visit '/'
      fill_in 'query', :with => 'test'
      click_button 'Submit'
      current_url.should match( /next_tweet\/create/ )
    end
  end
end
