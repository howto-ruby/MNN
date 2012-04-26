require 'spec_helper'

describe ActiveAdmin::Devise::SessionsController do
  include Devise::TestHelpers

  describe "A logged out AdminUser trying to login" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    end
    describe "GET new" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    end
  end
  
  describe "An AdminUser" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
    end
    describe "POST create" do
      it "should login and redirect to admin_dashboard_path" do
        post :create, {:admin_user => {:email => @user.email, :password => "welcome"}}
        response.should redirect_to(admin_dashboard_path)
      end
      it "should login and assign admin_current_user" do
        post :create, {:admin_user => {:email => @user.email, :password => "welcome"}}
        subject.current_admin_user.should_not be_nil
      end
    end
  end

end