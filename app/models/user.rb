class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable,
  devise :database_authenticatable, :recoverable, :rememberable, :trackable #, :validatable
  #need an on: => password change on the following so it only validates on password change ortherwise throws an error on create 
  #validates_presence_of :password_confirmation, :if => :password_changed?  
  validates :password, :presence =>true, :confirmation => true, :length => { :within => 6..40 }, :on => :create
    
  attr_accessor :login
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end  
end
