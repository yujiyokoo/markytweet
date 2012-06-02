require 'marky_markov'
require 'json'

class TweetGenerator
  # this is to be called with a keyword
  def self.generate( query )
    return "Please provide a keyword." if query == nil || query.empty?

    search_results = TwitterProxy.search( query )

    self.gen_sentence( search_results )
  end

  # this is to be called when twitter query is done in JS
  def self.generate_from_results( results )
    if( results[:results] )
      results[:results] = results[:results].map{ |arr| arr[1] }
    end

    self.gen_sentence( results )
  end

  def self.gen_sentence( input_hash )
    if input_hash.nil? ||  input_hash.empty?
      return "Sorry, but something has failed."
    elsif input_hash[:error]
      return "Sorry, there was an error: " + input_hash[:error]
    elsif input_hash[:results].nil? || input_hash[:results].size < 10
      return "Sorry, but I cannot find enough information about that word."
    else
      paragraph = input_hash[:results].map{ |elem| elem['text'] }.join(".\n")

      mm = MarkyMarkov::TemporaryDictionary.new(1)
      mm.parse_string( paragraph )

      return mm.generate_n_sentences(2)
    end
  end
end
