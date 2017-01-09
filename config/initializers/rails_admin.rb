RailsAdmin.config do |config|
    config.authorize_with do
        redirect_to main_app.root_path unless current_user.admin == true
    end
    config.model 'Category' do
        list do
            field:name
            field:subcategories
            # field :title
            # field :description
            # field :price
            # field :stock
        end

        exclude_fields :category_id
    end

    # config.model 'Product' do
    # list do

    # field :image
    # field :title
    # field :description
    # field :price
    # field :stock
    # end

    # end
    # config.model 'Category' do
    # list do

    # field :name

    # end
    #  exclude_fields :products_id
    # end

    ### Popular gems integration

    ## == Devise ==
    # config.authenticate_with do
    #   warden.authenticate! scope: :user
    # end
    # config.current_user_method(&:current_user)

    ## == Cancan ==
    # config.authorize_with :cancan

    ## == Pundit ==
    # config.authorize_with :pundit

    ## == PaperTrail ==
    # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

    ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

    ## == Gravatar integration ==
    ## To disable Gravatar integration in Navigation Bar set to false
    # config.show_gravatar true

    config.actions do
        dashboard # mandatory
        index # mandatory
        new
        export
        bulk_delete

        show_in_app
        dropzone do
            only Image, Product # Example Album
        end
        show
        edit
        delete
        ## With an audit adapter, you can add:
        # history_index
        # history_show
    end
end