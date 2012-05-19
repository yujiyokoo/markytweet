require 'spec_helper'

describe "NextTweetController" do
  context "when input empty" do
    it "should say provide content" do
      TweetGenerator.generate( '' ).should match( /provide.*keyword.*/i )
    end
  end
end
