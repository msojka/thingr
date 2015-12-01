class Thing < ActiveRecord::Base
  
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create
    
    include Dispatch
    callback do
      collection :users do
        on_add :notify_author!
        on_add :reset_authorship!
      end
      on_create :expire_cache!
    end
    
    contract do
      property :name
      property :description

      validates :name, presence: true
      validates :description, length: {in: 4..160}, allow_blank: true
      
      collection :users, 
        prepopulator: :prepopulate_users!,
        populate_if_empty: :populate_users!,
        skip_if: :all_blank do
          property :email
          validates :email, presence: true, email: true
          validate :authorships_limit_reached?
          
      private
        def authorships_limit_reached?
          return if model.authorships.find_all { |au| au.confirmed == 0 }.size < 5
          errors.add("user", "This user has too many unconfirmed authorships.")
        end
      end
      validates :users, length: { maximum: 3 }
      
    private
      def prepopulate_users!(options)
        (3 - users.size).times{ users << User.new }
      end
      
      def populate_users!(params, options)
        User.find_by_email(params[:email]) or User.new
      end
    end
  
    def process(params)
      validate(params[:thing]) do |f|
        f.save
        dispatch!
      end
    end
    
  private
    def reset_authorship!(user)
      user.model.authorships.find_by(thing_id: model.id).update_attribute(:confirmed, 0)
    end
    
    def notify_author!(user)
      # return UserMailer.welcome_and_added(user, model) if user.created?
      # UserMailer.thing_added(user, model)
    end
    
    def expire_cache!(thing)
      CacheVersion.for("thing/cell/grid").expire!
    end
  end
  
  class Update < Create
    action :update
    
    contract do
      property :name, writeable: false
      property :remove, virtual: true 
      
      collection :users, inherit: true, skip_if: :skip_user? do
        property :email, skip_if: :skip_email?
        
        def skip_email?(fragment, options)
          model.persisted?
        end
        
        def removeable?
          model.persisted?
        end
      end
      
    private
      def skip_user?(fragment, options)
        return true if fragment["remove"] == "1" and users.delete(users.find{ |u| u.id.to_s == fragment["id"] })
        return true if fragment["email"].blank?
      end
    end
  end

end