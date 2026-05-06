source "https://rubygems.org"

ruby ">= 3.2.0"

gem "rails", "~> 7.1"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Seguridad y autorizacion
gem "devise"
gem "pundit"
gem "paper_trail"

# Busqueda, paginacion y soft delete
gem "ransack"
gem "pagy"
gem "discard"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "dotenv-rails"
end
