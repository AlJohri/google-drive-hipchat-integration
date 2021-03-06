class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :hipchat_rooms

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info["email"]
        user.password = Devise.friendly_token[0,20]
        user.auth_token = auth.credentials.token
        user.name = auth.info["name"]   # assuming the user model has a name
        # user.image = auth.info.image # assuming the user model has an image
    end
  end

end
