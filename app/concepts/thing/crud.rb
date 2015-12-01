class Thing < ActiveRecord::Base
  
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create
    
    require_dependency "thing/form"
    self.contract_class = Form
    
    include Dispatch
    callback do
      collection :users do
        on_add :notify_author!
        on_add :reset_authorship!
      end
      on_change :expire_cache!
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