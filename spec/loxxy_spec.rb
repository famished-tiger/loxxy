# frozen_string_literal: true

require_relative '../lib/loxxy/version/'

RSpec.describe Loxxy do
  it 'has a version number' do
    expect(Loxxy::VERSION).not_to be_nil
  end
end
