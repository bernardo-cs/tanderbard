class AddStateSignerDate < ActiveRecord::Migration
  def up
  	add_column :emails, :state, :string
  	add_column :emails, :signer, :string
  	add_column :emails, :date, :string
  end

  def down
  	remove_column :emails, :state, :string
  	remove_column :emails, :signer, :string
  	remove_column :emails, :date, :string
  end
end
