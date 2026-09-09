# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruboty::GithubActions::Credential do
  let(:brain) { double("brain", data: {}) }

  describe ".save" do
    it "stores the credential in the brain" do
      described_class.save(brain, "alice", type: "pat", token: "token123")
      expect(brain.data["github_actions:credentials:alice"]).to eq(
        { type: "pat", token: "token123" }
      )
    end
  end

  describe ".find" do
    context "when the credential exists" do
      before do
        brain.data["github_actions:credentials:alice"] = { type: "pat", token: "token123" }
      end

      it "returns the credential" do
        credential = described_class.find(brain, "alice")
        expect(credential).to eq(type: "pat", token: "token123")
      end
    end

    context "when not found" do
      it "returns nil" do
        expect(described_class.find(brain, "bob")).to be_nil
      end
    end
  end
end
