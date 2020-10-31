# frozen_string_literal: true

require 'rails_helper'
require 'services/validations/ip_validator'

RSpec.describe Services::Validations::IpValidator do
  describe '#call' do
    let(:numeric_input) { 123 }
    let(:boolean_input) { true }
    let(:object_input) { Object.new }
    let(:string_non_ip_input) { 'abc' }
    let(:array_non_ip_input) { %w[abc 123] }
    let(:string_one_segments_ip) { '123' }
    let(:string_two_segments_ip) { '123.123' }
    let(:string_three_segments_ip) { '123.123.123' }
    let(:string_four_segments_ip) { '123.123.123.123' }
    let(:string_five_segments_ip) { '123.123.123.123.123' }
    let(:array_one_segments_ip) { ['123'] }
    let(:array_two_segments_ip) { ['123.123'] }
    let(:array_three_segments_ip) { ['123.123.123'] }
    let(:array_four_segments_ip) { ['123.123.123.123'] }
    let(:array_five_segments_ip) { ['123.123.123numeric_input.123.123'] }
    let(:nan_string_segments_ip) { '123.123.abc.123' }
    let(:nan_array_segments_ip) { ['123.123.123.123', '123.abc.123.123'] }
    let(:in_range_string_segments_ip) { '255.100.55.0' }
    let(:in_range_array_segments_ip) { ['255.100.55.0', '192.0.2.1'] }
    let(:out_range_string_segments_ip) { '256.100.55.0' }
    let(:out_range_array_segments_ip) { ['255.100.55.0', '-192.0.2.1'] }
    let(:string_localhost_ip) { '127.0.0.1' }
    let(:array_localhost_ip) { ['127.0.0.1'] }
    let(:string_non_routable_ip) { '0.0.0.0' }
    let(:array_non_routable_ip) { ['0.0.0.0'] }

    it 'Invalidate any imput that is not a string or an array of strins ' do
      result = Services::Validations::IpValidator.call(numeric_input)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(boolean_input)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(object_input)
      expect(result.status).to eq(:error)
    end

    it 'Invalidate an alphanumeric string as input' do
      result = Services::Validations::IpValidator.call(string_non_ip_input)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_non_ip_input)
      expect(result.status).to eq(:error)
    end

    it 'invalidate an ip string that has not 4 integer segments' do
      result = Services::Validations::IpValidator.call(string_one_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_one_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(string_two_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_two_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(string_three_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_three_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(string_five_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_five_segments_ip)
      expect(result.status).to eq(:error)
    end

    it 'validate an ip string that has exactly 4 integer segments' do
      result = Services::Validations::IpValidator.call(string_four_segments_ip)
      expect(result.status).to eq(:ok)
      result = Services::Validations::IpValidator.call(array_four_segments_ip)
      expect(result.status).to eq(:ok)
    end

    it 'invalidate an ip string that has non-numeric segment' do
      result = Services::Validations::IpValidator.call(nan_string_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(nan_array_segments_ip)
      expect(result.status).to eq(:error)
    end

    it 'validate an ip string with four numeric in range segments' do
      result = Services::Validations::IpValidator.call(in_range_string_segments_ip)
      expect(result.status).to eq(:ok)
      result = Services::Validations::IpValidator.call(in_range_array_segments_ip)
      expect(result.status).to eq(:ok)
    end

    it 'invalidate ip string that has numeric out of range segments' do
      result = Services::Validations::IpValidator.call(out_range_string_segments_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(out_range_array_segments_ip)
      expect(result.status).to eq(:error)
    end

    it 'invalidate ip string that represents localhost or non-routable address' do
      result = Services::Validations::IpValidator.call(string_localhost_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_localhost_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(string_non_routable_ip)
      expect(result.status).to eq(:error)
      result = Services::Validations::IpValidator.call(array_non_routable_ip)
      expect(result.status).to eq(:error)
    end
  end
end
