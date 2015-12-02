class Thing < ActiveRecord::Base
  
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create
    
    include Dispatch
    callback(:upload) do
      on_change :upload_image!, property: :file
    end
    callback do
      collection :users do
        on_add :notify_author!
        on_add :reset_authorship!
      end
      on_create :expire_cache!
    end
    
    contract do
      feature Disposable::Twin::Persisted
      extend Paperdragon::Model::Writer
      processable_writer :image
      
      property :name
      property :description
      property :image_meta_data, deserializer: { writeable: false }
      property :file, virtual: true

      validates :name, presence: true
      validates :description, length: {in: 4..160}, allow_blank: true
      validates :file,  file_size: { less_than: 1.megabyte },
                        file_content_type: { allow: ['image/jpeg', 'image/png'] }
      
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
        User.find_by(email: params["email"]) or User.new
      end
    end
  
    def process(params)
      validate(params[:thing]) do |f|
        dispatch!(:upload)
        f.save
        dispatch!
      end
    end
    
  private
    def upload_image!(contract)
      contract.image!(contract.file) do |v|
        v.process!(:original)
        v.process!(:thumb) { |job| job.thumb!("120x120#") }
      end
    end
    
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