class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :twitter_client, only: [:create]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render top_index_path
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    make_picture
    respond_to do |format|
      if @post.save
        @client.update("#{@post.content}\nhttps://powertweet.herokuapp.com/posts/#{@post.id}\r")
        format.html { redirect_to new_post_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
