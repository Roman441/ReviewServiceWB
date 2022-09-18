# Load the Rails application.
lib_path = File.join Dir.pwd, 'lib'
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include? lib_path

require File.expand_path('../application', __FILE__)

require_relative "application"
require 'importer'

Dotenv.load

# Initialize the Rails application.
Rails.application.initialize!