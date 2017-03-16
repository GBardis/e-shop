class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_presence_of :email
  has_many :orders, dependent: :destroy
  has_many :authorizations
  has_many :messages
  has_many :comments
  has_many :favorite_products, dependent: :destroy
  has_many :favorites, through: :favorite_products, source: :product
  has_many :payment_methods_tokens, dependent: :destroy
  has_many :addresses

  ratyrate_rater
  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  # def password_required?
  #  super && provider.black?
  # end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s, token: auth.credentials.token, secret: auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', auth['info']['email']).first
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0, 10]
        user.name = auth.info.name
        user.email = auth.info.email
        if auth.provider == 'twitter'
          user.save(validate: false)

        else
          user.save
        end
      end
      authorization.username = auth.info.nickname
      authorization.user_id = user.id
      authorization.save
    end
    authorization.user
  end

  def has_payment_info?
    braintree_customer_id
  end
end
