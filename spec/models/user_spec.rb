require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { have_many(:questions).dependent(:destroy) }
  it { have_many(:answers).dependent(:destroy) }
  it { have_many(:votes).dependent(:destroy) }
  it { have_many(:comments).dependent(:destroy) }
end