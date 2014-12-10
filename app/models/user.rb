class User < ActiveRecord::Base
	acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  has_many :lists, dependent: :destroy

  def self.authentic_with_token?(email, token)
		u = User.find_by(email: email)
		u && u.authentication_token == token
	end
end
