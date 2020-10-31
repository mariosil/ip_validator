# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Validations', type: :request do
  describe 'POST /validate_ip' do
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

    it 'returns http not_acceptable if params are not a string or array of atrings' do
      post '/validations/validate_ip', params: { ips: numeric_input }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: boolean_input }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: object_input }
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http not_acceptable if params are only a alphanumeric string' do
      post '/validations/validate_ip', params: { ips: string_non_ip_input }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_non_ip_input }
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'return http not_acceptable if ip string has not 4 integer segments' do
      post '/validations/validate_ip', params: { ips: string_one_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_one_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: string_two_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_two_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: string_three_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_three_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: string_five_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_five_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http success' do
      post '/validations/validate_ip', params: { ips: string_four_segments_ip }
      expect(response).to have_http_status(:success)
      post '/validations/validate_ip', params: { ips: array_four_segments_ip }
      expect(response).to have_http_status(:success)
    end

    it 'return http not_acceptable if ip string has non-numeric segment' do
      post '/validations/validate_ip', params: { ips: nan_string_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: nan_array_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'return http success if ip string has in range segments' do
      post '/validations/validate_ip', params: { ips: in_range_string_segments_ip }
      expect(response).to have_http_status(:success)
      post '/validations/validate_ip', params: { ips: in_range_array_segments_ip }
      expect(response).to have_http_status(:success)
    end

    it 'return http not_acceptable if ip string has out of range segments' do
      post '/validations/validate_ip', params: { ips: out_range_string_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: out_range_array_segments_ip }
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'return http not_acceptable if ip string is localhost or non-routable' do
      post '/validations/validate_ip', params: { ips: string_localhost_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_localhost_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: string_non_routable_ip }
      expect(response).to have_http_status(:not_acceptable)
      post '/validations/validate_ip', params: { ips: array_non_routable_ip }
      expect(response).to have_http_status(:not_acceptable)
    end
  end
end
