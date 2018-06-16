class GithubLogger < BaseLogger
  file_path Rails.root.join('log', 'github.log')
end
