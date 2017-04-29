class GithubService
  # https://developer.github.com/webhooks/#events
  HookEventPolicy = ["commit_comment", "issue_comment", "issues",
                     "pull_request", "pull_request_review_comment",
                     "pull_request_review"].freeze

  def initialize(full_access_token)
    @client = Octokit::Client.new(access_token: full_access_token)
  end

  # def orgs
  #   @client.organizations
  # end

  # type can be `all`, `public`, `member`, `sources`, `forks`, or `private`
  # def repos_by_org(org_name, type = "all")
  #   @client.org_repos(org_name, type: type)
  # end

  # see https://developer.github.com/v3/repos/#list-your-repositories
  def collect_all_repos
    repos = @client.repos(nil, per_page: 100, sort: 'full_name', direction: :asc).map(&:full_name) +
            @client.repos(nil, per_page: 100, sort: 'full_name', direction: :desc).map(&:full_name).reverse
    repos.uniq
  end

  def auto_create_hook(repo_fullname, hook_url, hook_name = "web")
    @client.create_hook(repo_fullname, hook_name, { url: hook_url, content_type: "json" }, events: HookEventPolicy, active: true)
  end

  # def show_hook(repo_fullname, hook_id)
  #   @client.hook(repo_fullname, hook_id)
  # end

  def auto_delete_hook(repo_fullname, hook_id)
    @client.remove_hook(repo_fullname, hook_id)
  end

  def permission_scopes
    @client.scopes
  end
end
