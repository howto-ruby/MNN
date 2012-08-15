gem install bundler --pre

if ([ "$TRAVIS_RUBY_VERSION" == "jruby" ]); then
  rm -rf Gemfile.lock
  bundle update 
fi

echo "Setting up database.yml"
cp config/database.yml.travis config/database.yml

echo "Creating databases and migrating it"
psql -c 'create database mnn_test;' -U postgres
bundle exec rake db:create --trace
bundle exec rake db:migrate --trace