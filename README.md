# ruboty-github-actions

A ruboty plugin to trigger GitHub Actions workflows via chat.

## Installation

Add this line to your ruboty project's Gemfile:

```ruby
gem "ruboty-github-actions"
```

And then execute:

```console
$ bundle
```

## Usage

### Set a credential

Register a GitHub Personal Access Token for a user:

```
ruboty github actions set credential <user> <token>
```

Example:

```
ruboty github actions set credential alice ghp_xxxxxxxxxxxx
```

The credential is stored in the ruboty brain.

### Dispatch a workflow

Trigger a workflow run:

```
ruboty github actions run <repo> <workflow> <branch> [key=value,key2=value2 ...]
```

Example:

```
ruboty github actions run tomoasleep/myapp deploy main env=production
```

The workflow runs as the user who sent the message.

## Configuration

| Environment variable | Description |
|----------------------|-------------|
| `RUBOTY_GITHUB_ACTIONS_API_URL` | GitHub API base URL (optional, for testing/local emulation) |

## Development

Run the test suite:

```console
$ bundle exec rspec
```
