# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruboty::GithubActions::Actions::Client do
  describe ".build" do
    it "creates an Octokit client with the access token" do
      client = described_class.build(type: "pat", token: "token123")
      expect(client).to be_a(Octokit::Client)
      expect(client.access_token).to eq("token123")
    end

    context "when the api url is configured" do
      around do |example|
        original = ENV["RUBOTY_GITHUB_ACTIONS_API_URL"]
        ENV["RUBOTY_GITHUB_ACTIONS_API_URL"] = "https://github.emulate.localhost"
        example.run
        original ? ENV["RUBOTY_GITHUB_ACTIONS_API_URL"] = original : ENV.delete("RUBOTY_GITHUB_ACTIONS_API_URL")
      end

      it "uses the configured api endpoint" do
        client = described_class.build(type: "pat", token: "token123")
        expect(client.api_endpoint).to eq("https://github.emulate.localhost/")
      end
    end
  end
end
