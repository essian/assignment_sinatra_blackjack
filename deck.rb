class Deck

attr_accessor :cards

  def initialize(cards = new_deck)
    @cards = cards
  end

  def new_deck
    @cards = ranks.product(suits).shuffle
  end

  def ranks
    (2..10).to_a << :ace << :jack << :queen << :king
  end

  def suits
    [:spade, :heart, :diamond, :club]
  end
end