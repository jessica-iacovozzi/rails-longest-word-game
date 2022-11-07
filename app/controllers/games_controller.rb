require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array('a'..'z').sample(10)
  end

  def score
    @word = params[:word]
    @api = "https://wagon-dictionary.herokuapp.com/#{@word}"
    words_serialized = URI.open(@api).read
    verified_words = JSON.parse(words_serialized)
    @letters_array = params[:letters].split('')
    @word_array = @word.split('')
    @included = @word_array.all? { |letter| @letters_array.include?(letter) }
    @response = if @word == params[:letters]
                  "Sorry but #{@word.upcase} can't be built out of #{params[:letters]}"
                elsif @included == true && verified_words['found'] == false
                  "Sorry but #{@word.upcase} is not a valid English word..."
                elsif @included == true && verified_words['found'] == true
                  "Congrats! #{@word.upcase} is an English word!"
                else
                  'Are you even trying?'
                end
  end
end
