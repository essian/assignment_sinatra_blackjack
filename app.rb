require 'sinatra'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require './helpers/blackjack_helper.rb'

enable :sessions

helpers BlackjackHelper

get '/' do
  session.clear
  session['purse'] ||= 1000
  erb :welcome
end

get '/blackjack' do


  deck = session['deck'] = new_deck.shuffle
  player_cards = session['player_cards'] = deal(deck, 2)
  dealer_cards = session['dealer_cards'] = deal(deck, 2)

  erb :blackjack, locals: { player_cards: player_cards,
                            dealer_cards: dealer_cards.first, wording: nil,
                            bet: session['bet'], purse: session['purse']}
end

post '/blackjack/hit' do
  session['player_cards'] << deal(session['deck'], 1).flatten
  player_cards = session['player_cards']
  if bust?(player_cards)
    redirect('/blackjack/stay')
  else
    erb :blackjack, locals: {player_cards: session['player_cards'],
                             dealer_cards: session['dealer_cards'].first, wording: nil,
                             bet: session['bet'], purse: session['purse'] }
  end
end



# welcome -> form :player_name, creates a game instance, assigns the player name
get '/blackjack/stay' do
  dealer_cards = session['dealer_cards']
  while calc_value(dealer_cards) < 17
    dealer_cards << deal( session['deck'], 1 )
  end
  wording = final_result(dealer_cards, session['player_cards'])
  erb :blackjack, locals: {player_cards: session['player_cards'],
                             dealer_cards: session['dealer_cards'], wording: wording,
                             bet: session['bet'], purse: session['purse'] }

end

get '/bet' do
  erb :bet
end

post '/bet' do
  handle_bet(params[:bet], session['purse'])
end
