class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Comment, :create
    
    include Dispatch
    callback do
      on_change :sign_up_sleeping!, property: :user
    end
    
    contract do
      property :body
      property :weight, prepopulator: -> (*) { self.weight = "0" }
      property :thing
      
      def self.weights
        { "0" => "Nice!", "1" => "Rubbish!"}
      end
      
      def weights
        [self.class.weights.to_a, :first, :last]
      end
      
      validates :body, length: { in: 6..160 }
      validates :weight, inclusion: { in: weights.keys }
      validates :thing, :user, presence: true
      
      property :user,
                prepopulator: -> (*) { self.user = User.new },
                populator: -> (fragment, *) { self.user = User.find_by(email: fragment[:email]) || User.new } do
        property :email
        validates :email, presence: true, email: true
      end
    end
    
    def process(params)
      validate(params[:comment]) do |f|
        dispatch!
        f.save
      end
    end
    
    def thing
      model.thing
    end
  
  private
    def setup_model!(params)
      model.thing = Thing.find(params[:id])
    end
    
    def sign_up_sleeping!(comment)
      auth = Tyrant::Authenticatable.new(comment.user.model)
      auth.confirmable!
      auth.sync
    end
  end
end