require 'ostruct'

module Moonshot
  # This module supports massaging of the incoming environment.
  module EnvironmentParser
    def self.parse(log)
      log.debug('Starting to parse environment.')

      # Ops Bastion servers export AWS_CREDENTIAL_FILE, instead of key and
      # secret keys, so we support both here. We then set them as environment
      # variables which will be respected by aws-sdk.
      parse_credentials_file if ENV.key?('AWS_CREDENTIAL_FILE')

      # Ensure the aws-sdk is able to find a set of credentials.
      creds = Aws::CredentialProviderChain.new(OpenStruct.new).resolve

      raise 'Unable to find AWS credentials!' unless creds

      log.debug('Environment parsing complete.')
    end

    def self.parse_credentials_file
      File.open(ENV.fetch('AWS_CREDENTIAL_FILE')).each_line do |line|
        key, val = line.chomp.split('=')
        case key
        when 'AWSAccessKeyId' then ENV['AWS_ACCESS_KEY_ID'] = val
        when 'AWSSecretKey'   then ENV['AWS_SECRET_ACCESS_KEY'] = val
        end
      end
    end
  end
end
