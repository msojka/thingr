require 'test_helper'

describe ThingsController do
  let (:thing) { Thing::Create.(thing: {name: "Rails"}).model }
  
  describe "new" do  
    it do
      get :new
      assert_select "form #thing_name"
      assert_select "form #thing_name.readonly", false
    end
  end
  
  describe "create" do  
    it do #valid
      post :create, {thing: {name: "Bad Religion"}}
      assert_redirected_to thing_path(Thing.last)
    end
    
    it do #invalid
      post :create, {thing: {name: ""}}
      assert_select ".error"
    end
  end
  
  describe "edit" do  
    it do
      get :edit, id: thing.id
      assert_select "form #thing_name.readonly[value='Rails']"
    end
  end
  
end