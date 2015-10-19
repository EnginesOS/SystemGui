class User < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  validates :password, confirmation: true, length: { within: 6..128 }, on: :create
  validates :password, confirmation: true, length: { within: 6..128 }, on: :update, allow_blank: true

end
