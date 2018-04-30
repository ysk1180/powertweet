module ApplicationHelper
  def get_twitter_card_info(post)
    twitter_card = {}
    if post
      twitter_card[:url] = "https://powertweet.herokuapp.com/posts/#{post.id}"
      twitter_card[:image] = "https://s3-ap-northeast-1.amazonaws.com/powertweet-production/images/#{post.user_id}.png"
    else
      twitter_card[:url] = 'https://powertweet.herokuapp.com/'
      twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/powertweet/master/app/assets/images/twittertop.png"
    end
    twitter_card[:title] = "POWERTWEET"
    twitter_card[:card] = 'summary_large_image'
    twitter_card[:description] = '文字が入った画像を自動生成し、力強いツイートができるサービスです。'
    twitter_card
  end
end
