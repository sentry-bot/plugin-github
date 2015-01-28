require 'cinch'
require 'octokit'
require 'action_view'
require 'twitter-text'
require 'uri'

module Cinch
  module Plugins
    module Sentry
      class GitHub
        include Cinch::Plugin
        include Twitter::Extractor
        include ActionView::Helpers::DateHelper

        # Fetch all github links
        listen_to :channel

        def initialize(*)
          super
          @bot = bot
        end

        def listen(m)
          # Exctract urls
          urls = extract_urls(m.message)

          # Go through all links
          urls.each do |url|
            # Parse the url
            uri = URI.parse(url.to_s)

            # We only handle GitHub links
            case uri.host
            when "www.github.com", "github.com"
              begin
                if not uri.path.to_s.empty?
                  # Split the path by forward slash
                  split = uri.path.split "/"

                  # Check if we got a repository name in the link
                  if split[2].nil? then
                    # Fetch the user information
                    user = Ocotkit.user split[1]

                    # Reply with the information
                    m.reply("[%s] %s (repos: %s)" % [
                      Format(:green, "GitHub"),
                      Format(:bold, user.name.nil? ? user.login : user.name),
                      Format(:teal, user.public_repos.to_s),
                    ])
                  else
                    # Fetch the repository information
                    repo = Octokit.repo split[1] + "/" + split[2]

                    # Fetch the latest commit
                    message = repo.rels[:commits].get.data.first.commit.message

                    # Reply with the information
                    m.reply("[%s][%s] %s (commit: %s) (last update: %s) (stars: %s) (forks: %s)" % [
                      Format(:green, "GitHub"),
                      Format(:blue, repo.owner.login),
                      Format(:bold, repo.name),
                      Format(:orange, message.gsub(%r{[\n]+}," ")),
                      Format(:orange, time_ago_in_words(repo.pushed_at).gsub(%r{(about[\s]+)?}, "") + " ago"),
                      Format(:teal, repo.stargazers_count.to_s),
                      Format(:teal, repo.forks.to_s)
                    ])
                  end
                end
              rescue Exception => e
                # Log the exception
                puts e

                # Send back error message
                m.reply("[%s] %s" % [
                  Format(:green, "GitHub"),
                  Format(:bold, "Invalid GitHub link")
                ])
              end
            end
          end
        end
      end
    end
  end
end