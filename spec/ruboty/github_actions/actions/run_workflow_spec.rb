# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruboty::GithubActions::Actions::RunWorkflow do
  let(:brain) { double("brain", data: {}) }
  let(:robot) { double("robot", brain: brain) }
  let(:message) { double("message", robot: robot, from_name: "alice", reply: nil) }
  let(:client) { instance_double(Octokit::Client) }

  before do
    allow(message).to receive(:[]).with(1).and_return("owner/repo")
    allow(message).to receive(:[]).with(2).and_return("deploy.yml")
    allow(message).to receive(:[]).with(3).and_return("main")
    allow(message).to receive(:[]).with(4).and_return("env=production")
  end

  context "with PAT" do
    before do
      brain.data["github_actions:credentials:alice"] = { type: "pat", token: "token123" }
      allow(Ruboty::GithubActions::Actions::Client).to receive(:build).and_return(client)
      allow(client).to receive(:workflow_dispatch).with("owner/repo", "deploy.yml", "main", { inputs: { env: "production" } }).and_return(true)
    end

    it "dispatches the workflow and replies" do
      described_class.new(message).call

      expect(Ruboty::GithubActions::Actions::Client).to have_received(:build).with(
        { type: "pat", token: "token123" }
      )
      expect(client).to have_received(:workflow_dispatch).with("owner/repo", "deploy.yml", "main", { inputs: { env: "production" } })
      expect(message).to have_received(:reply).with(/dispatched/i)
    end

    context "when the dispatch fails" do
      before do
        allow(client).to receive(:workflow_dispatch).with("owner/repo", "deploy.yml", "main", { inputs: { env: "production" } }).and_return(false)
      end

      it "replies with a failure" do
        described_class.new(message).call
        expect(message).to have_received(:reply).with(/failed/i)
      end
    end
  end

  context "when no credential is found" do
    it "replies with an error" do
      described_class.new(message).call
      expect(message).to have_received(:reply).with(/no credential/i)
    end
  end
end
