web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rails runner lib/tasks/do_everything.rb --loop
