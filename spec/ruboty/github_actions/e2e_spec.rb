# frozen_string_literal: true

require "spec_helper"
require "net/http"
require "timeout"

RSpec.describe "GitHub Actions e2e (emulate.dev)", :e2e do
  let(:base_url) { "http://localhost:4010" }

  before(:all) do
    system("pkill -f 'emulator.mjs' 2>/dev/null || true")
    emulator_dir = File.expand_path("../../support/emulator", __dir__)
    unless File.exist?(File.join(emulator_dir, "node_modules", "emulate"))
      system("npm", "install", "--prefix", emulator_dir, "--silent", "--no-fund", "--no-audit") or raise "npm install failed"
    end
    @pid = Process.spawn(
      "node", "emulator.mjs",
      chdir: emulator_dir,
      out: "/tmp/ruboty-github-actions-emulate.log",
      err: "/tmp/ruboty-github-actions-emulate.log"
    )
    Timeout.timeout(30) do
      loop do
        begin
          Net::HTTP.get_response(URI("http://localhost:4010/meta"))
          break
        rescue Errno::ECONNREFUSED, SocketError
          sleep 0.5
        end
      end
    end
    @original_api_url = ENV["RUBOTY_GITHUB_ACTIONS_API_URL"]
    ENV["RUBOTY_GITHUB_ACTIONS_API_URL"] = "http://localhost:4010"
  end

  after(:all) do
    Process.kill("TERM", @pid) if @pid
    Process.wait(@pid) rescue nil
    @original_api_url ? ENV["RUBOTY_GITHUB_ACTIONS_API_URL"] = @original_api_url : ENV.delete("RUBOTY_GITHUB_ACTIONS_API_URL")
  end

  let(:client) do
    Ruboty::GithubActions::Actions::Client.build(type: "pat", token: "test_token_admin")
  end

  it "connects to the emulator and authenticates" do
    repo = client.repository("admin/hello-world")
    expect(repo.full_name).to eq("admin/hello-world")
  end

  it "dispatches a workflow and receives 204" do
    result = client.workflow_dispatch("admin/hello-world", "ci.yml", "main", inputs: { env: "production" })
    expect(result).to be(true)
  end

  it "records the workflow run" do
    expect(client.workflow_dispatch("admin/hello-world", "ci.yml", "main", inputs: {})).to be(true)
    runs = client.workflow_runs("admin/hello-world", "ci.yml")
    expect(runs.total_count).to be >= 1
    run = runs.workflow_runs.first
    expect(run.event).to eq("workflow_dispatch")
    expect(run.head_branch).to eq("main")
    expect(run.status).to eq("queued")
  end
end
