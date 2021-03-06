# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task update_feed: :environment do
  require 'line/bot' # gem 'line-bot-api'
  require 'twitter'

  client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end

  client_t = Twitter::REST::Client.new do |config|
    # 事前準備で取得したキーのセット
    config.consumer_key         = ENV['TWITTER_API_KEY']
    config.consumer_secret      = ENV['TWITTER_API_SECRET']
  end
  since_id = nil
  today = Time.zone.today.strftime('%Y-%m-%d')
  yesterday = (Time.zone.today - 1).strftime('%Y-%m-%d')
  line_ids = Url.all.pluck(:line_id).uniq
  line_ids.each do |line_id|
    targets = Url.where(line_id: line_id).pluck(:url)
    content = ''
    if targets.present?
      targets.each do |target|
        search = "url:#{target.tr('-', '+')} since:#{yesterday}_07:00:00_JST until:#{today}_07:00:00_JST"
        tweets = client_t.search(search, count: 10, result_type: 'recent', exclude: 'retweets', since_id: since_id)
        urls = []
        tweets.take(10).each do |tw|
          screen_name = tw.user.screen_name
          id = tw.id
          urls << "https://twitter.com/#{screen_name}/status/#{id}"
        end
        urls.each.with_index(1) do |url, i|
          content = "#{content}< #{target} をシェアするツイート＞\n" if i == 1
          content = "#{content}#{i}. #{url}\n"
        end
      end
      message = {
        type: 'text',
        text: content
      }
      response = client.push_message(line_id, message)
      p response
    end
  end
  'OK'
end
