require 'twitter'
require 'dalli'

class TwitterProxy
  def self.normalise_n_escape( query_str )
    normalised = query_str.strip.downcase.gsub(/^#/, '' ).split.sort.join(' ')
    URI.escape(normalised, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def self.query( qstr, retention_seconds = 3600, &block )
    escaped = '#system_special_trend_key'
    if !qstr.nil?
      escaped = normalise_n_escape( qstr )
    end
    dc = Dalli::Client.new
    cache = dc.get( escaped ) 
    if !cache.nil?
      # if cache still valid or rate limit is less than 5
      if ( Time.now - cache[:created_at] ) < retention_seconds || Twitter.rate_limit_status.remaining_hits <= 5
        return { :results => cache[:value] }
      end
    end
    if Twitter.rate_limit_status.remaining_hits <= 5
      return { :results => 'Sorry, but it seems we are out of twitter search quota. Please wait for a while' }
    else
      begin
        yield dc, escaped
      rescue Twitter::Error => err
        return  { :error => err.message }
      end
      cache = dc.get( escaped )
      return { :results => cache[:value] }
    end
  end

  def self.search( qstr, retention_seconds = 3600 )
    self.query( qstr, retention_seconds ) do |dc, key|
      tc = Twitter::Client.new
      returned = tc.search( key, :rpp => 100 )
      dc.set( key, { :created_at => Time.now, :value => returned } )
    end
  end

  def self.global_trends( retention_seconds = 3600 )
    self.query( nil, retention_seconds ) do |dc, key|
      tc = Twitter::Client.new
      returned = tc.trends
      dc.set( key, { :created_at => Time.now, :value => returned } )
    end
  end
end
