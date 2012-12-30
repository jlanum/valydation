web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec rails runner lib/tasks/create_notifications.rb --loop
