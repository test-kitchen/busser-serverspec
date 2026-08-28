source "https://rubygems.org"

gemspec

group :cookstyle do
  gem "cookstyle", ">= 9.0.0"
end

group :test do
  gem "aruba", ">= 2.0"
  gem "base64" # cucumber needs it; not a default gem on Ruby 4.0
  gem "cucumber", ">= 11.1"
  gem "rake"
  gem "serverspec", ">= 2.43"
end

group :development do
  gem "simplecov"
end
