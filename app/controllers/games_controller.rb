require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = ("a".."z").to_a
    10.times { @letters << alphabet[rand(0..25)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if valid?(@letters, @word) && english?(@word)
      @result = "success"
      session[:score] += (@word.length**2)*100
      @score = session[:score]
    elsif valid?(@letters, @word) && !english?(@word)
      @result = "That's not english"
    elsif !valid?(@letters, @word)
      @result = "That can't be built from the original script"
    end
  end

  def english?(word)
    JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)['found']
  end

  def valid?(letters, word)
    letters_hash = Hash.new(0)
    letters.chars.each { |char| letters_hash[char] += 1 }
    word_hash = Hash.new(0)
    word.chars.each { |char| word_hash[char] += 1 }
    return word_hash.all? { |char, num| letters_hash[char] >= num }
  end

end
