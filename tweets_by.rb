# Returns something that may sound like a tweet from a given user
# Run this file by passing it a twitter handle as an argument (i.e. ruby tweets_by.rb ecanals)
# Using the marky_markov gem to generate a dictionary of words based on a user's tweets and re-tweets. https://github.com/zolrath/marky_markov

require 'marky_markov'
require 'json'
require 'oauth'

username = ARGV[0]

def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new("YOUR_API_KEY", "YOUR_API_SECRET",
    { :site => "https://api.twitter.com",
      :scheme => :header
    })
  token_hash = { :oauth_token => oauth_token,:oauth_token_secret => oauth_token_secret}
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end
access_token = prepare_access_token("YOUR_ACCESS_TOKEN", "YOUR_ACCESS_TOKEN_SECRET")


response = JSON.parse(access_token.request(:get, "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{username}&count=200").body)


markov = MarkyMarkov::TemporaryDictionary.new

response.each do |r|
  markov.parse_string r['text']
end


puts(sprintf("%s %s %s %s %s.", markov.generate_3_words, markov.generate_3_words.downcase!, markov.generate_3_words.downcase!, markov.generate_3_words.downcase!, markov.generate_3_words.downcase!)[0..139])
