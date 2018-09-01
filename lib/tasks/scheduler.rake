# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task update_feed: :environment do
  require 'line/bot' # gem 'line-bot-api'

  client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end

  user_ids = ['U96a2790cfba425cb1e422d6f00c3a877']
  message = {
    type: 'text',
    text: 'テスト'
  }
  response = client.multicast(user_ids, message)
  'OK'
end
