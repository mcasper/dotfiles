require "json"
require "net/http"

def get_latest_version(package)
  response = Net::HTTP.get(URI("https://hex.pm/api/packages/#{package}"))
  releases = JSON.parse(response)["releases"]
  filtered_releases = releases.reject { |r| r["version"].match?(/rc|alpha|beta|demo/) }
  filtered_releases.first["version"].split(".").first(2).join(".")
end

in_lines = File.read("mix.exs").strip.split("\n")
version_regex = /\d+\.\d+(\.\d+)?/
package_regex = /{:([a-zA-Z0-9\-_]+),/
seen_deps = false

result = in_lines.map do |line|
  if !seen_deps && line.match?(/def(p)? deps do/)
    seen_deps = true
    line
  elsif seen_deps && line.match?(/~> #{version_regex}/)
    package = line.match(package_regex).captures.first
    latest_version = get_latest_version(package)
    line.gsub(version_regex, latest_version)
  else
    line
  end
end

File.open("mix.exs", "w") { |f| f.write(result.join("\n")); f.puts }
