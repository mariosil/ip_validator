# frozen_string_literal: true

require 'services/application_service'

module Services
  module Validations
    # Contains the logic to validate IP addresses.
    class IpValidator < Services::ApplicationService
      attr_reader :ip_input

      def initialize(ip_input)
        @ip_input = ip_input
      end

      def call
        result = OpenStruct.new status: :ok,
                                data: { valid_ips: [] },
                                message: ''
        ips = validate_types(ip_input)
        ips.each do |ip|
          segments = four_segments_of_integers(ip)
          segments = segments_of_integers(segments)
          segments = segments_with_numeric_ip_ranges(segments)
          segments = not_localhost_segments(segments)
          result.data[:valid_ips] << segments.join('.')
          result.message = 'All provided values are valid IP addresses'
        end
        result
      rescue StandardError => e
        result.status = :error
        result.message = e.message
        result
      end

      private

      def validate_types(ip_input)
        ips = ip_input.is_a?(Array) ? ip_input : [ip_input]
        unless ips.map { |ip| ip.is_a? String }.all?
          raise "#{ips}: IP(s) input should be a String or Array of Strings"
        end

        ips
      end

      def four_segments_of_integers(ip)
        segments = ip.split('.')
        unless segments.size == 4
          raise "#{ip}: IP should have 4 segments of Integers"
        end

        segments
      end

      def segments_of_integers(segments)
        begin
          segments = segments.map { |s| Integer(s) }
        rescue ArgumentError
          raise "#{segments.join('.')}: Each IP segment should be an Integer"
        end

        segments
      end

      def segments_with_numeric_ip_ranges(segments)
        numeric_ip_range = (0..255)
        unless segments.map { |s| numeric_ip_range.include? s }.all?
          raise "#{segments.join('.')}: IP segments should contain integer " \
                'values between 0 and 255'
        end

        segments
      end

      def not_localhost_segments(segments)
        if segments == [127, 0, 0, 1]
          raise "#{segments.join('.')}: IP is localhost"
        end
        if segments == [0, 0, 0, 0]
          raise "#{segments.join('.')}: IP is a non-routable adress"
        end

        segments
      end
    end
  end
end
