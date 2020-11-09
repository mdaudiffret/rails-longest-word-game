require 'json'
require 'open-uri'

class GamesController < ApplicationController
  # methods used for calculation
  @grid = []

  def new_array
    @grid = (0...10).map { (65 + rand(26)).chr }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    result = {}
    score_and_message = score_and_message(attempt, grid)
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt)
        [score, 'well done']
      else
        [0, 'not an english word']
      end
    else
      [0, 'not in the grid']
    end
  end

  def compute_score(attempt)
    attempt.size
  end

  # metods triggered by actions
  def new
    # action here
    new_array
  end

  def score
    @outcome = run_game(params[:word], @grid)
  end
end
