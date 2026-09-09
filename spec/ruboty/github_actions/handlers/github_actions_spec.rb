# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruboty::GithubActions::Handlers::GithubActions do
  let(:robot) { double("robot", brain: double(data: {})) }

  describe ".actions" do
    it "defines a set credential action" do
      action = described_class.actions.find { |a| a.name == "set credential" }
      expect(action).to be_a(Ruboty::Action)
      expect(action.name).to eq("set credential")
    end

    it "defines a run workflow action" do
      action = described_class.actions.find { |a| a.name == "run" }
      expect(action).to be_a(Ruboty::Action)
      expect(action.name).to eq("run")
    end
  end
end
