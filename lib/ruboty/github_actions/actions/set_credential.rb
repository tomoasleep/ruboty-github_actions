# frozen_string_literal: true

module Ruboty
  module GithubActions
    module Actions
      class SetCredential < Ruboty::Actions::Base
        def call
          user = message[1]
          token = message[2]

          Credential.save(message.robot.brain, user, type: "pat", token: token)
          message.reply("Credential saved for #{user}")
        end
      end
    end
  end
end
