class GithubService
  HookEventPolicy = ["commit_comment", "create", "delete", "deployment", "deployment_status", "download",
                     "follow", "fork", "fork_apply", "gist", "gollum", "issue_comment", "issues", "member",
                     "page_build", "public", "pull_request", "pull_request_review_comment", "push", "release",
                     "status", "team_add", "watch"].freeze

  def initialize(github_token)
    @client = Octokit::Client.new(access_token: github_token)
  end

  # def orgs
  #   @client.organizations
  # end

  # type can be `all`, `public`, `member`, `sources`, `forks`, or `private`
  # def repos_by_org(org_name, type = "all")
  #   @client.org_repos(org_name, type: type)
  # end

  def collect_all_repos
    @client.repositories.map(&:full_name)
  end

  def auto_create_hook(repo_fullname, hook_url, hook_name = "web")
    @client.create_hook(repo_fullname, hook_name, { url: hook_url, content_type: "json" }, events: HookEventPolicy)
  end

  # def show_hook(repo_fullname, hook_id)
  #   @client.hook(repo_fullname, hook_id)
  # end

  def auto_delete_hook(repo_fullname, hook_id)
    @client.remove_hook(repo_fullname, hook_id)
  end

end
