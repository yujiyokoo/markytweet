PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
$:.push( File.expand_path(File.dirname(__FILE__) + "/../app/") )

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  MarkyTweet.tap { |app|  }
end

require 'nokogiri'
require 'capybara/dsl'
require 'timecop'

Capybara.app = MarkyTweet

