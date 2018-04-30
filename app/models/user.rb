class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
   provider = auth_hash[:provider] #providerはどのサービスで認証したのかを見分けるもの
   uid = auth_hash[:uid]
   nickname = auth_hash[:info][:nickname]
   image_url = auth_hash[:info][:image]
   oauth_token = auth_hash[:credentials][:token]
   oauth_token_secret = auth_hash[:credentials][:secret]

   #find_or_create_by()は()の中の条件のものが見つければ取得し、なければ新しく作成するというメソッド
   self.find_or_create_by(provider: provider,uid: uid) do |user|
     user.nickname = nickname
     user.image_url = image_url
     user.oauth_token = oauth_token
     user.oauth_token_secret = oauth_token_secret
   end
  end
end
