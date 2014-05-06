require 'rspec'
require 'card'

describe Card do
  subject(:card) { Card.new(:diamond, :queen) }
  its(:suit) { should be (:diamond) }
  its(:value) { should eql (:queen) }

  it "tells you its ranking" do
    expect(card.rank).to eql(12)
  end

  let(:other_card) { Card.new(:spade, :king) }
  let(:same_val_card) { Card.new(:spade, :queen) }

  # let(:other_card) { double('other_card', :rank => 13 ) }
  it "can compare it's rank to other cards ranks" do
    expect(card > (other_card)).to be_false
  end




end

