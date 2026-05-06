FROM ruby:3.3

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile /app/Gemfile
RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bash", "-lc", "if [ -f bin/rails ]; then bin/rails server -b 0.0.0.0; else echo 'Inicializa Rails con: docker compose run --rm web rails new . --force --database=postgresql --css=tailwind --javascript=esbuild'; sleep infinity; fi"]
