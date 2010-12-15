require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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

end
