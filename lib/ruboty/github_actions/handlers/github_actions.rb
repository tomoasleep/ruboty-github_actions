# frozen_string_literal: true

module Ruboty
  module GithubActions
    module Handlers
      class GithubActions < Ruboty::Handlers::Base
        on(
          /github actions set credential (?<user>\S+) (?<token>\S+)\z/,
          name: "set credential",
          description: "Set a GitHub PAT credential for a user"
        )

        on(
          /github actions run (?<repo>\S+) (?<workflow>\S+) (?<ref>\S+)(?<inputs> [\S,=]+)?\z/,
          name: "run",
          description: "Dispatch a GitHub Actions workflow"
        )

        def set_credential(message)
          Ruboty::GithubActions::Actions::SetCredential.new(message).call
        end

        def run(message)
          Ruboty::GithubActions::Actions::RunWorkflow.new(message).call
        end
      end
    end
  end
end
