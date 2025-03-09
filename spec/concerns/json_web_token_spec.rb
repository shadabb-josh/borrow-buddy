require 'rails_helper'
require 'jwt'

class JsonWebTokenTestClass
  include JsonWebToken
end

RSpec.describe JsonWebTokenTestClass do
  let(:test_class) { JsonWebTokenTestClass.new }
  let(:payload) { { user_id: 1 } }
  let(:token) { test_class.jwt_encode(payload) }

  describe '#jwt_encode' do
    it 'encodes a payload into a JWT' do
      expect(token).to be_a(String)
    end
  end

  describe '#jwt_decode' do
    it 'decodes a JWT back to the original payload' do
      decoded_payload = test_class.jwt_decode(token)
      expect(decoded_payload[:user_id]).to eq(1)
    end

    it 'raises an error if token is invalid' do
      expect { test_class.jwt_decode('invalid.token') }.to raise_error(JWT::DecodeError)
    end
  end
end
