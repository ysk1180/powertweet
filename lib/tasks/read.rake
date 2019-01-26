desc "This task is called by the Heroku scheduler add-on"
task :read_blog => :environment do
  require 'line/bot' # gem 'line-bot-api'

  client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET_READ"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN_READ"]
  }

  mes = [
    '今日も一日お疲れさま。',
    'おつかれ〜',
    '今日もいい仕事したね〜'
  ].sample

  blog = [
    'https://ysk-pro.hatenablog.com/entry/principles-of-programming',
    'https://ysk-pro.hatenablog.com/entry/perfect-ruby-on-rails',
    'https://ysk-pro.hatenablog.com/entry/rspec',
    'https://ysk-pro.hatenablog.com/entry/secure-website',
    'https://ysk-pro.hatenablog.com/entry/secure-application',
    'https://ysk-pro.hatenablog.com/entry/unix',
    'https://ysk-pro.hatenablog.com/entry/object-orientation',
    'https://ysk-pro.hatenablog.com/entry/sql',
    'https://ysk-pro.hatenablog.com/entry/mysql',
    'https://ysk-pro.hatenablog.com/entry/mysql-practice',
    'https://ysk-pro.hatenablog.com/entry/web',
    'https://ysk-pro.hatenablog.com/entry/expert',
    'https://ysk-pro.hatenablog.com/entry/unix-philosophy',
    'https://ysk-pro.hatenablog.com/entry/teaming',
    'https://ysk-pro.hatenablog.com/entry/teamgeek',
    'https://ysk-pro.hatenablog.com/entry/tcp',
    'https://ysk-pro.hatenablog.com/entry/figure',
    'https://ysk-pro.hatenablog.com/entry/api',
    'https://ysk-pro.hatenablog.com/entry/agile'
  ].sample

  user_ids = ReadUser.all.pluck(:line_id)
  message = {
    type: 'text',
    text: "#{mes}\n今日読むブログ記事はコチラ↓\n#{blog}\n毎日読んで知識を定着させよう！"
  }

  response = client.multicast(user_ids, message)

  "OK"
end
