class Addusernametoauthorization < ActiveRecord::Migration[5.0]
  def change
     add_column :authorizations, :username, :string
 end
end
