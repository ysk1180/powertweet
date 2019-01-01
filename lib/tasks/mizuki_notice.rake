# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task mizuki_notice_22: :environment do
  require 'line/bot' # gem 'line-bot-api'

  client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET_MIZUKI']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN_MIZUKI']
  end

  mes = [
    '大好きだよ',
    '愛してるよ',
    'みーたん天使！',
    'バブバブ',
    'ちゅーーーーーー！',
    '早くいちゃいちゃしよー！',
    'I love you!',
    '天使ちゃん！',
    'You are angel!',
    '大当たり！キエエエエエ',
    'ウホウホ',
  ].sample

  message = {
    type: 'text',
    text: "みーたん、10時だよ(^^)\nお薬飲もうねー！\n#{mes}"
  }
  line_id = "Ubf9f353de2dca66dd235666b7014b4bc"
  response = client.push_message(line_id, message)
  p response
  'OK'
end

desc 'This task is called by the Heroku scheduler add-on'
task mizuki_notice_23: :environment do
  require 'line/bot' # gem 'line-bot-api'

  client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET_MIZUKI']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN_MIZUKI']
  end

  mes = [
    'ベッドで待ってるぜ！',
    '今日はエッ◯',
    '早く寝ようね(^^)',
    'みーたんがいい夢見れますように！',
    '明日はもーっと楽しくなるよ、バブ太郎！',
    '筋トレうええええええええい',
    'みーたん大大大好き！！',
  ].sample

  message = {
    type: 'text',
    text: "みーたん、もう11時だよー。\nおやすみぃ〜\n#{mes}"
  }
  line_id = "Ubf9f353de2dca66dd235666b7014b4bc"
  response = client.push_message(line_id, message)
  p response
  'OK'
end
