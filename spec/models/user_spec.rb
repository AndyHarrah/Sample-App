require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
			:name => "Example User",
			:email => "user@example.com",
			:password => "foobar",
			:password_confirmation => "foobar"
		}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
	end

  it "should require an email" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
	end

  it "should require a name2" do
    no_name_user = User.new;
    no_name_user.email = "user@example.com"
    no_name_user.valid?.should_not == true
	end

  it "should require a name3" do
    no_name_user = User.new(@attr);
    no_name_user.name = ""
    no_name_user.valid?.should_not == true
	end

  it "should reject names that are too long" do
    no_name_user = User.new(@attr.merge(:name => ("a" * 51)))
    no_name_user.should_not be_valid
	end

  it "should reject emails that are too short" do
    no_name_user = User.new(@attr.merge(:email => "12"))
    no_name_user.should_not be_valid
	end

  it "should accept valid emails" do
		emails = %w(user@foo.com THE_USER@foo.bar.org first.last@foo.jp)
    emails.each do |address|
      valid_user = User.new(@attr.merge(:email => address))
			valid_user.should be_valid
    end
	end

  it "should not accept invalid emails" do
		emails = %w(user@foo,com user_at_foo.org example.user@foo.)
    emails.each do |address|
      invalid_user = User.new(@attr.merge(:email => address))
			invalid_user.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
		user1 = User.new(@attr)
		user1.save
		user2 = User.new(@attr)
    user2.should_not be_valid
  end

  it "should reject duplicate emails (mixed case)" do
		user1 = User.new(@attr.merge(:email => "foo@foo.com"))
		user1.save
		user2 = User.new(@attr.merge(:email => "FOO@FOO.COM"))
    user2.should_not be_valid
  end

  it "should reject duplicate emails2" do
		user1 = User.new(@attr)
		user2 = User.new(@attr)
		user1.save
    user2.should_not be_valid
  end

  describe "password validations" do

		it "should require a password" do
			user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
			user.should_not be_valid
    end

		it "should require a matching password confirmation" do
			user = User.new(@attr.merge(:password_confirmation => "invalid"))
			user.should_not be_valid
    end

		it "should reject short passwords" do
			short = "a" * 5
			hash = @attr.merge(:password => short, :password_confirmation => short)
			user = User.new(@attr.merge(hash))
			user.should_not be_valid
    end

		it "should reject long passwords" do
			long = "a" * 41
			hash = @attr.merge(:password => long, :password_confirmation => long)
			user = User.new(@attr.merge(hash))
			user.should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
			@user = User.create!(@attr)
    end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
  	end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end

		describe "has_password? method" do

			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
      end

			it "should be false if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end

    end

  end

end
