require 'test_helper'

describe ThingsController do
  let (:page) { response.body }
  
  let (:thing) do
    thing = Thing::Create.(thing: {name: "Rails"}).model

    Comment::Create.(comment: {body: "Excellent", weight: "0", user: {email: "zavan@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "!Well.", weight: "1", user: {email: "jonny@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "Cool stuff!", weight: "0", user: {email: "chris@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "Improving.", weight: "1", user: {email: "hilz@trb.org"}}, id: thing.id)

    thing
  end
  
  describe "show" do
    it do
      get :show, id: thing.id
      response.body.must_match /Rails/
      assert_select "input.button[value=?]", "Create Comment"
      assert_select ".comment_user_email"
      assert_select ".comments .comment"
    end
  end
  
  describe "#new" do
    it "#new [HTML]" do
      get :new

      page.must_have_css "form #thing_name"
      page.wont_have_css "form #thing_name.readonly"

      # 3 author email fields
      page.must_have_css("input.email", count: 3) # TODO: how can i say "no value"?
    end
  end
  
  describe "create" do  
    it do #valid
      post :create, {thing: {name: "Bad Religion"}}
      assert_redirected_to thing_path(Thing.last)
    end
    
    it do # invalid.
      post :create, {thing: {name: ""}}
      page.must_have_css ".error"

      # 3 author email fields
      # page.must_have_css("input.email", count: 3)
    end
  end
  
  describe "edit" do  
    it do
      get :edit, id: thing.id
      assert_select "form #thing_name.readonly[value='Rails']"
    end
  end
  
  describe "#create_comment" do
    it do
      post :create_comment, id: thing.id,
                            comment: {  body: "That green jacket!", weight: "1",
                                        user: {email: "seuros@trb.org"} }
      assert_redirected_to thing_path(thing)
      flash[:notice].must_equal "Created comment for Rails"
    end
  end
  
  describe "#next_comments" do
    it do
      xhr :get, :next_comments, id: thing.id, page: 2
      response.body.must_match /zavan@trb.org/
    end
  end
  
end