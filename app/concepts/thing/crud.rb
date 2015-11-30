class Thing < ActiveRecord::Base
  
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create
    
    require_dependency "thing/form"
    self.contract_class = Form
  
    def process(params)
      validate(params[:thing]) do |f|
        f.save
        reset_authorships!
      end
    end
    
  private
    def reset_authorships!
      model.authorships.each{ |a| a.update_attribute(:confirmed, 0) }
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