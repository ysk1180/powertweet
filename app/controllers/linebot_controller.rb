# frozen_string_literal: true

class LinebotController < ApplicationController
  require 'line/bot' # gem 'line-bot-api'
  require 'twitter'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    events.each do |event|
      case event
        # メッセージが送信された場合の対応（機能①）
      when Line::Bot::Event::Message
        case event.type
          # ユーザーからテキスト形式のメッセージが送られて来た場合
        when Line::Bot::Event::MessageType::Text
          # event.message['text']：ユーザーから送られたメッセージ
          input = event.message['text']
          content = ''
          line_id = event['source']['userId']

          case input
          when /.*(追加|登録).*/
            url = input.match(/.*→(.+)/)[1]
            if url.present?
              Url.find_or_create_by(url: url, line_id: line_id)
              content = 'OK! 登録されているURLは「リスト」と送信すれば見れるよ'
            else
              content = 'URLが見つからないよ。追加→URL という形で送ってね〜'
            end
          when /.*(削除).*/
            url = input.match(/.*→(.+)/)[1]
            if url.present?
              destroy_url = Url.find_by(url: url, line_id: line_id)
              if destroy_url.present?
                destroy_url.destroy
                content = 'OK!'
              else
                content = 'URLが見つからないよ。正しいURLかどうか確認してね〜'
              end
            else
              content = 'URLが見つからないよ。削除→URL という形で送ってね〜'
            end
          when /.*(リスト).*/
            urls = Url.where(line_id: line_id).pluck(:url)
            if urls.present?
              content = "登録されているURLはこちらです。\n"
              urls.each.with_index(1) do |url, i|
                content = "#{content}#{i}. #{url}\n"
              end
            else
              content= 'URLを登録していないよ〜'
            end
          when /.*(今).*/
            client_t = Twitter::REST::Client.new do |config|
              # 事前準備で取得したキーのセット
              config.consumer_key         = ENV['TWITTER_API_KEY']
              config.consumer_secret      = ENV['TWITTER_API_SECRET']
            end
            since_id = nil
            today = Time.zone.today.strftime('%Y-%m-%d')
            yesterday = (Time.zone.today - 1).strftime('%Y-%m-%d')
            targets = Url.where(line_id: line_id).pluck(:url)
            content = ''
            if targets.present?
              targets.each do |target|
                search = "url:#{target.tr('-', '+')} since:2018-08-26_07:00:00_JST until:#{today}_17:00:00_JST"
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
            else
              content = 'シェアされたツイートはなかったよ〜'
            end
          else
            content = "＜使い方＞\n・URLの追加：「追加→追加したいURL」\n・URLの削除：「削除→削除したいURL」\n・URLの確認：「リスト」\n・前日の朝7時〜当日の朝7時での検索結果：「今」"
          end

        end
        message = {
          type: 'text',
          text: content
        }
        client.reply_message(event['replyToken'], message)
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
