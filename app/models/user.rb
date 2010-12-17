# == Schema Information
# Schema version: 20101211184326
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password	
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-\.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
						:length => { :maximum => 50 }

  validates :email, :presence => true,
						:length => { :minimum => 3 },
            :format => { :with => email_regex },
						:uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
											 :confirmation => true,
											 :length => { :within => 6..40 }

	before_save	:encrypt_password

	def self.authenticate(email, password)
		u = find_by_email(email)
		return nil if u.nil?
		return u if u.has_password?(password)
		return nil
  end

	def has_password?(input)
		encrypted_password == encrypt(input)
  end

  private

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(self.password)
    end

		def encrypt(input)
			secure_hash("#{self.salt}--#{input}")
    end

		def make_salt
			secure_hash("#{Time.now.utc}--#{self.password}")
		end

		def secure_hash(input)
			Digest::SHA2.hexdigest(input)
		end

end
