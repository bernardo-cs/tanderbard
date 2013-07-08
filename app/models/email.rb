class Email < ActiveRecord::Base
  attr_accessible :body, :from, :to, :state, :signer, :date, :authentication,:subject
end
