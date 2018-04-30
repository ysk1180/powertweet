class PostsController < ApplicationController
  before_action :twitter_client, only: [:create]

  def show
    render top_index_path
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    make_picture
    if @post.save
      @client.update("#{@post.content}\n#POWERTWEET\nhttps://powertweet.herokuapp.com/posts/#{@post.id}\r")
      redirect_to new_post_path, notice: 'パワーツイート完了！次は別の種類のパワーツイートをどうぞ！'
    else
      render :new
    end
  end

  private
  def post_params
    params.require(:post).permit(:content, :power, :user_id, :picture, :kind)
  end

  def make_picture
    sentense = ""
    content = @post.power.gsub(/\r\n|\r|\n/," ")
    if content.length <= 50 then
      n = (content.length / 10).floor + 1
      n.times do |i|
        s_num = i * 10
        f_num = s_num + 9
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 60
    else
      n = (content.length / 15).floor + 1
      n.times do |i|
        s_num = i * 15
        f_num = s_num + 14
        range =  Range.new(s_num,f_num)
        sentense += content.slice(range)
        sentense += "\n" if n != i+1
      end
      pointsize = 45
    end
    font = ".fonts/ipag.ttc"
    case @post.kind
    when "thunder" then
      base = "thunder.png"
      color = "white"
    when "muscle" then
      base = "muscle.png"
      color = "black"
    when "cat" then
      base = "cat.png"
      color = "white"
    when "love" then
      base = "love.png"
      color = "white"
    else
      base = "fire.png"
      color = "white"
    end
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color
      i.gravity 'center'
      i.pointsize pointsize
      i.draw "text 0,0 '#{sentense}'"
    end
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
    case Rails.env
      when 'production'
        bucket = storage.directories.get('powertweet-production')
        png_path = 'images/' + @post.user_id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/powertweet-production' + "/" + png_path
      when 'development'
        bucket = storage.directories.get('powertweet-development')
        png_path = 'images/' + @post.user_id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/powertweet-development' + "/" + png_path
    end
  end

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end
end
