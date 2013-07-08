# coding: utf-8
class UserCredential < ActiveRecord::Base
  attr_accessible :email, :password

	  def self.retrieve_user_emails
		credentials = UserCredential.first

		aiss = Aiss::MailAiss.new(credentials[:email],credentials[:password])
		puts '------- vou comecar a sacar mails --------'
		aiss.convert_received_emails.each do |converted_mail|
			puts '------- vou imprimir um mail --------'
			p converted_mail
			if converted_mail[:signer_email]
				#é um mail aiss
				email = Email.new(:body => converted_mail[:body], 
													:from => converted_mail[:from],
													:date => converted_mail[:date], 
													:to => converted_mail[:to],
													:signer => converted_mail[:signer_email],
													:state => 'unread',
													:authentication => converted_mail[:authenticated],
													:subject => converted_mail[:subject])
				email.save!
			else
				email = Email.new(:body => converted_mail[:body], 
													:from => converted_mail[:from],
													:to => converted_mail[:to],
													:state => 'unread',
													:subject => converted_mail[:subject])
				email.save!
			end
		end

	end
end


