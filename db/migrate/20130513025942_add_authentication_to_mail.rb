class AddAuthenticationToMail < ActiveRecord::Migration
  def change
  	add_column :emails, :authentication, :string
  end
end
