# frozen_string_literal: true

module Ruboty
  module GithubActions
    module Actions
      class Client
        class << self
          def build(credential)
            Octokit::Client.new(access_token: credential[:token], **base_options)
          end

          private

          def base_options
            options = {}
            options[:api_endpoint] = ENV["RUBOTY_GITHUB_ACTIONS_API_URL"] if ENV["RUBOTY_GITHUB_ACTIONS_API_URL"]
            options
          end
        end
      end
    end
  end
end
