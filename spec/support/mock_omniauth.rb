OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:facebook,
  { uid: '12345',
    info: {
      email: "omniauth@foobar.com",
      name: 'foobar'
    },
    provider: 'facebook'
  }
)
OmniAuth.config.add_mock(:google_oauth2,
  { uid: '12345',
    info: {
      email: "omniauth@foobar.com",
      name: 'foobar'
    },
    provider: 'google_oauth2'
  }
)
OmniAuth.config.add_mock(:github,
  { "provider" => "github",
    "uid" => "12345",
    "info" => {
      "nickname" => "marsz",
      "email" => "omniauth@foobar.com",
      "name" => "MarsZ Chen",
      "image" => "https://avatars.githubusercontent.com/u/169716?v=3",
      "urls"=> { "GitHub"=>"https://github.com/marsz", "Blog"=>"http://rubyist.marsz.tw" }
    },
    "credentials" => {
      "token"=>"811c25691f505035dba5417535a053ebc0dedeb1", "expires"=>false
    },
    "extra"=> {
      "raw_info"=> {
        "login"=>"marsz",
        "id"=>169716,
        "avatar_url"=>"https://avatars.githubusercontent.com/u/169716?v=3",
        "gravatar_id"=>"",
        "url"=>"https://api.github.com/users/marsz",
        "html_url"=>"https://github.com/marsz",
        "followers_url"=>"https://api.github.com/users/marsz/followers",
        "following_url"=>"https://api.github.com/users/marsz/following{/other_user}",
        "gists_url"=>"https://api.github.com/users/marsz/gists{/gist_id}",
        "starred_url"=>"https://api.github.com/users/marsz/starred{/owner}{/repo}",
        "subscriptions_url"=>"https://api.github.com/users/marsz/subscriptions",
        "organizations_url"=>"https://api.github.com/users/marsz/orgs",
        "repos_url"=>"https://api.github.com/users/marsz/repos",
        "events_url"=>"https://api.github.com/users/marsz/events{/privacy}",
        "received_events_url"=>"https://api.github.com/users/marsz/received_events",
        "type"=>"User",
        "site_admin"=>false,
        "name"=>"MarsZ Chen",
        "company"=>nil,
        "blog"=>"http://rubyist.marsz.tw",
        "location"=>"Taiwan Taipei",
        "email"=>nil,
        "hireable"=>true,
        "bio"=>nil,
        "public_repos"=>18,
        "public_gists"=>9,
        "followers"=>28,
        "following"=>20,
        "created_at"=>"2009-12-19T06:44:27Z",
        "updated_at"=>"2015-12-16T10:19:07Z",
        "private_gists"=>147,
        "total_private_repos"=>1,
        "owned_private_repos"=>1,
        "disk_usage"=>13082,
        "collaborators"=>0,
        "plan"=>{
          "name"=>"free", "space"=>976562499, "collaborators"=>0, "private_repos"=>0
        }
      }
    }
  }
)
