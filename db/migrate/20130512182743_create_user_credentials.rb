class CreateUserCredentials < ActiveRecord::Migration
  def change
    create_table :user_credentials do |t|
      t.string :email
      t.text :password

      t.timestamps
    end
  end
end
