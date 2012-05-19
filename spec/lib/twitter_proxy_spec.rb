require 'spec_helper'

describe 'TwitterProxy' do
  context "when searching" do
    before(:each) do
      @rl_status = mock( '@rl_status' )
      Twitter.stub!( :rate_limit_status ).and_return( @rl_status )
      @rl_status.stub!( :remaining_hits ).and_return( 0 )
      @tc = mock( '@tc' )
      Twitter::Client.stub!( :new ).and_return( @tc )
      @dalli = mock( '@dalli' )
      Dalli::Client.stub!( :new ).and_return( @dalli )
    end
    context "upon cache hit" do
      context "if cache less than 1 hr old" do
        before( :each ) do
          @dalli.stub!( :get ).and_return( { :created_at => Time.now, :value => 'cache content' } )
        end
        it "should return cache" do
          TwitterProxy.query( 'qstr' ).should eql( { :results => 'cache content' } )
        end
      end
      context "if cache more than 1 hr old" do
        before( :each ) do
          @dalli.stub!( :get ).and_return( { :created_at => Time.at( Time.now.to_i - 3700), :value => 'cache!' } )
        end
        context "if remaining hits <= 5" do
          before( :each ) do
            @rl_status.stub!( :remaining_hits ).and_return( 5 )
          end
          it "should return cache" do
            TwitterProxy.search( 'qstr' ).should eql( { :results => 'cache!' } )
          end
          it "should not query twitter" do
            @tc.should_not_receive( :search )
          end
        end
        context "if remaining hits > 5" do
          before( :each ) do
            @now = Time.now
            @rl_status.stub!( :remaining_hits ).and_return( 6 )
          end
          it "should query twitter" do
            @dalli.should_receive( :set ).with( 'keyword', { :created_at => @now, :value => 'twitter search result' } )
            @tc.should_receive( :search ).and_return( 'twitter search result' )
            Timecop.freeze( @now ) do
              TwitterProxy.search( 'keyword' )
            end
          end
        end
      end
    end
    context "upon cache miss" do
      before( :each ) do
        @dalli.stub!( :get ).and_return( nil, { :value => 'gotvalue' } )
      end
      context "when there are > 5 remaining hits" do
        before( :each ) do
          @rl_status.stub!( :remaining_hits ).and_return( 6 )
          @now = Time.now
        end
        it "should query twitter" do
          @dalli.should_receive( :set ).with( 'keyword', { :created_at => @now, :value => 'twitter search result' } )
          @tc.should_receive( :search ).and_return( 'twitter search result' )
          Timecop.freeze( @now ) do
            TwitterProxy.search( 'keyword' ).should eql( { :results => 'gotvalue' } )
          end
        end
      end
      context "when there are <= 5 remaining hits" do
        before( :each ) do
          @rl_status.stub!( :remaining_hits ).and_return( 5 )
        end
        it "should not query twitter" do
          @tc.should_not_receive( :search )
          TwitterProxy.search( 'foo' )[:results].should match( /out.*of.*search.*quota/i )
        end
      end
    end
  end
  context "when getting trends" do
  end
end
