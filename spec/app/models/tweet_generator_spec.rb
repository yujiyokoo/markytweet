require 'spec_helper'

describe "NextTweetController" do
  before( :each ) do
    @mm = mock( '@mm' )
    MarkyMarkov::TemporaryDictionary.stub!(:new).and_return( @mm )
  end

  context "when generating from a keyword" do
    context "when input empty" do
      it "should say provide content" do
        TweetGenerator.generate( '' ).should match( /provide.*keyword.*/i )
      end
    end
    context "when search results come back with nil" do
      before(:each) do
        TwitterProxy.should_receive( :search ).and_return nil
      end
      it "should say 'error'" do
        TweetGenerator.generate( 'foo' ).should match( /failed/ );
      end
    end
    context "when results contain an error" do
      before(:each) do
        TwitterProxy.should_receive( :search ).and_return( { :error => 'ERR' } )
      end
      it "should say 'error'" do
        TweetGenerator.generate( 'foo' ).should match( /error: ERR/ );
      end
    end
    context "when results < 10" do
      before(:each) do
        TwitterProxy.should_receive( :search ).and_return( { :results => [1, 2, 3] } )
      end
      it "should say 'dunno enough'" do
        TweetGenerator.generate( 'foo' ).should match( /not.*enough/ );
      end
    end
    context "when enough results come bock" do
      before(:each) do
        TwitterProxy.should_receive( :search ).and_return( { :results => [ { 'text' => 'tweet content' } ] * 10 } )
        @mm.should_receive( :parse_string )
        @mm.should_receive( :generate_n_sentences ).and_return 'sentences'
      end
      it "should generate string" do
        TweetGenerator.generate( 'foo' ).should == 'sentences'
      end
    end
  end

  context "when generating from search results" do
    context "when search results empty" do
      it "should report error" do
        TweetGenerator.generate_from_results( {} ).should match( /failed/ )
      end
    end
    context "when search results contains error" do
      it "should report error" do
        TweetGenerator.generate_from_results( { :error => 'FOO' } ).should match( /error: FOO/ )
      end
    end
    context "when not enough results" do
      it "should say I don't know" do
        TweetGenerator.generate_from_results( { :results => [] } ).should match( /not.*enough/ )
      end
    end
    context "when sufficient results" do
      before( :each ) do
        @mm.should_receive( :parse_string ).with( ( ['foo'] * 10 ).join( ".\n" ) )
        @mm.should_receive( :generate_n_sentences ).and_return( 'n sentences' )
      end
      it "should generate a string" do
        reshash = { :results => [[ :index, { 'text' => 'foo' } ]] * 10 }
        TweetGenerator.generate_from_results( reshash ).should == 'n sentences'
      end
    end
  end
end
