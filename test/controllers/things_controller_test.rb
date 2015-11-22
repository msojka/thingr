describe ThingsController do
  

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


end