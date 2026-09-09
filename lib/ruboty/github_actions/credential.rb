# frozen_string_literal: true

module Ruboty
  module GithubActions
    class Credential
      PREFIX = "github_actions:credentials"

      class << self
        def save(brain, user, attributes)
          brain.data[key_for(user)] = attributes
        end

        def find(brain, user)
          brain.data[key_for(user)]
        end

        private

        def key_for(user)
          "#{PREFIX}:#{user}"
        end
      end
    end
  end
end
