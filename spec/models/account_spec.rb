require 'rails_helper'

RSpec.describe Account do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
end