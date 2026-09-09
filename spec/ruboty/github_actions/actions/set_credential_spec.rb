# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruboty::GithubActions::Actions::SetCredential do
  let(:brain) { double("brain", data: {}) }
  let(:robot) { double("robot", brain: brain) }
  let(:message) { double("message", robot: robot, from_name: "alice", reply: nil) }

  describe "#call" do
    it "saves the credential and replies" do
      allow(message).to receive(:[]).with(1).and_return("alice")
      allow(message).to receive(:[]).with(2).and_return("token123")

      described_class.new(message).call

      expect(brain.data["github_actions:credentials:alice"]).to eq(
        { type: "pat", token: "token123" }
      )
      expect(message).to have_received(:reply).with(/saved/i)
    end
  end
end
