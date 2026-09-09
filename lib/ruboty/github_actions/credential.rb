# frozen_string_literal: true

module Ruboty
  module GithubActions
    class Credential
      PREFIX = "github_actions:credentials"
      QIITA_GITHUB_NAMESPACE = "github"

      class << self
        def save(brain, user, attributes)
          brain.data[key_for(user)] = attributes
        end

        def find(brain, user)
          brain.data[key_for(user)] || from_qiita_github(brain, user)
        end

        private

        def key_for(user)
          "#{PREFIX}:#{user}"
        end

        def from_qiita_github(brain, user)
          token = brain.data[QIITA_GITHUB_NAMESPACE].to_h[user]
          { type: "pat", token: token } if token
        end
      end
    end
  end
end
