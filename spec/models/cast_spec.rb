require 'rails_helper'

RSpec.describe Cast, :type => :model do
  it "correct search results" do
    actor_search_results = Cast.search("Cast", "name", "Tom Cruise")
    expect(actor_search_results).to include(Cast.find_by_name("Tom Cruise"))
  end
end
