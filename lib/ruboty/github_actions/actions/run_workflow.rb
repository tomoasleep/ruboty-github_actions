# frozen_string_literal: true

module Ruboty
  module GithubActions
    module Actions
      class RunWorkflow < Ruboty::Actions::Base
        def call
          repo = message[1]
          workflow = message[2]
          ref = message[3]
          inputs = parse_inputs(message[4])

          credential = Credential.find(message.robot.brain, message.from_name)
          return message.reply("No credential found for #{message.from_name}") unless credential

          client = Client.build(credential)
          return message.reply("Workflow #{workflow} dispatch failed for #{repo}") unless client.workflow_dispatch(repo, workflow, ref, inputs: inputs)

          message.reply("Workflow #{workflow} dispatched for #{repo}")
        end

        private

        def parse_inputs(raw)
          return {} unless raw

          raw.split(",").each_with_object({}) do |pair, hash|
            key, value = pair.split("=", 2)
            hash[key.to_sym] = value
          end
        end
      end
    end
  end
end
