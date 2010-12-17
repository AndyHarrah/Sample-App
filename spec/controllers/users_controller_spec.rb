require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end

  end

  describe "GET 'new'" do

		before(:each) do
			@user = Factory(:user)
			# User.stub!(:find, @user.id).and_return(@user)
		end

		it "should be successful" do
			get :show, :id => @user.id
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id => @user.id
			assigns(:user).should == @user	
		end

	end

end
