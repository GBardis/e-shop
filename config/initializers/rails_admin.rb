RailsAdmin.config do |config|
  config.authorize_with do
    if current_user
      redirect_to main_app.root_path unless current_user.admin == true
    end
    redirect_to main_app.root_path unless current_user
  end
  config.model 'Category' do
    list do
      field :name
      field :subcategories
      field :products
      items_per_page 20
    end
    show do
      field :name
      field :subcategories
      field :products
    end
    edit do
      field :name
      field :subcategories
      field :products
    end
  end

  config.model 'Product' do
    list do
      field :title
      field :description
      field :price
      field :stock
      field :images
      field :category
      field :active
    end
    edit do
      field :title
      field :description
      field :price
      field :stock
      field :category
      field :images
      field :active
    end
  end

  config.model 'Image' do
    list do
      field :product
      field :image
      items_per_page 20
    end
  end

  config.model 'AverageCache' do
    visible false
  end
  config.model 'RatingCache' do
    visible false
  end
  config.model 'OverallAverage' do
    visible false
  end
  #  config.model 'Rate' do
  # visible false
  # end

  # config.model 'Category' do
  # field :products do
  #  nested_form false
  # end
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
      only Product # Example Album
    end
    show
    edit
    delete
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
