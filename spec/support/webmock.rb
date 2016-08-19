module Webmock
  def webmock_all!
    # example
    stub_request(:get, "https://google.com/api.json")
      .to_return(headers: { 'Content-Type' => 'application/json' }, body: '{ "ok": true }')

    # slack
    stub_request(:post, /https:\/\/hooks\.slack\.com\/services\//)
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: "", headers: { 'Content-Type' => 'application/json' })

    # github repos
    stub_request(:get, /https:\/\/api\.github\.com\/user\/orgs/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 200, body: '[{"login":"5fpro","id":1500106,"url":"https://api.github.com/orgs/5fpro"}]', headers: { 'Content-Type' => 'application/json' })

    # github repos_by_org
    stub_request(:get, /https:\/\/api\.github\.com\/orgs\/[0-9a-z]+\/repos/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 200, body: '[{"id":3160692,"name":"titto","full_name":"5fpro/titto"}]', headers: { 'Content-Type' => 'application/json' })

    # github collect_all_repos
    stub_request(:get, /https:\/\/api\.github\.com\/user\/repos/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 200, body: '[{"id":26844289,"name":"chef_explorer","full_name":"5fpro/chef_explorer"}]', headers: { 'Content-Type' => 'application/json' })

    # github auto_create_hook
    stub_request(:post, /https:\/\/api\.github\.com\/repos\/[0-9a-z]+\/hooks/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 200, body: '{"url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310","test_url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310/test","ping_url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310/pings","id":7628310,"name":"web","active":true,"events":["commit_comment","create","delete","deployment","deployment_status","fork","gollum","issue_comment","issues","member","page_build","public","pull_request","pull_request_review_comment","push","release","status","team_add","watch"],"config":{"url":"https://hooks.slack.com/services/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","content_type":"json"},"last_response":{"code":null,"status":"unused","message":null},"updated_at":"2016-03-10T08:03:12Z","created_at":"2016-03-10T08:03:12Z"}', headers: { 'Content-Type' => 'application/json' })

    # github show_hook
    stub_request(:get, /https:\/\/api\.github\.com\/repos\/[0-9a-z]+\/hooks\/[0-9]+/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 200, body: '{"url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310","test_url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310/test","ping_url":"https://api.github.com/repos/phrase5036/chef-template/hooks/7628310/pings","id":7628310,"name":"web","active":true,"events":["commit_comment","create","delete","deployment","deployment_status","fork","gollum","issues","issue_comment","member","page_build","public","pull_request","pull_request_review_comment","push","release","status","team_add","watch"],"config":{"url":"https://hooks.slack.com/services/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","content_type":"json"},"last_response":{"code":200,"status":"active","message":"OK"},"updated_at":"2016-03-10T08:03:12Z","created_at":"2016-03-10T08:03:12Z"}', headers: { 'Content-Type' => 'application/json' })

    # github auto_delete_hook
    stub_request(:delete, /https:\/\/api\.github\.com\/repos\/[0-9a-z]+\/hooks\/[0-9]+/)
      .with(headers: { 'Accept' => 'application/vnd.github.beta+json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'token token', 'User-Agent' => 'Octokit Ruby Gem 2.1.1' })
      .to_return(status: 204, body: "{}", headers: { 'Content-Type' => 'application/json' })
  end
end
