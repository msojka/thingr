require 'test_helper'

class CommentCrudTest < MiniTest::Spec
  let(:thing) { Thing::Create.(thing: { name: 'Ruby' }).model }
  
  describe "Create" do
    it "perists valid" do
      res, op = Comment::Create.run(
        thing_id: thing.id,
        comment: {
          body: 'Fantastic',
          weight: '1',
          user: { email: 'john@doe.org' }
        }
      )
      comment = op.model
      
      comment.persisted?.must_equal true
      comment.body.must_equal 'Fantastic'
      comment.weight.must_equal 1
      
      comment.user.persisted?.must_equal true
      comment.user.email.must_equal 'john@doe.org'
      
      op.thing.must_equal thing
    end
    
    it "invalid email" do
      res, op = Comment::Create.run(
        thing_id: thing.id,
        comment: {
          user: { email: 'john@' }
        }
      )
      
      res.must_equal false
      op.errors.messages[:"user.email"].must_equal ["is invalid"]
    end
    
    # TODO cover more validations
  end
  
end