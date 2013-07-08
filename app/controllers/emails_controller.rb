require 'Aiss'

## states
# sent
# read
# unread

class EmailsController < ApplicationController
  before_filter :authenticate, :count_unread_emails
  #before_filter :get_all , :only => :index

  # GET /emails
  # GET /emails.json
  def count_unread_emails
    @unread_email = Email.where(:state => 'unread').count
  end
  
  def index
    if (params[:render])
      if (params[:render] == 'inbox')
       @emails = Email.where(:state => ['read','unread']).order("created_at DESC")
      else
        @emails = Email.where(:state => params[:render]).order("created_at DESC")
      end
    else
      @emails = Email.where(:state => ['read','unread']).order("created_at DESC")
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @emails }
    end
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = Email.find(params[:id])
    @email.state = 'read'
    @email.save!

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email }
    end
  end

  # GET /emails/new
  # GET /emails/new.json
  def new
    @autocomplete_items = Email.uniq.pluck(:to)
    @email = Email.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email }
    end
  end

  # GET /emails/1/edit
  def edit
    @email = Email.find(params[:id])
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(params[:email])
    @email[:from] = @@username
    @email[:state] = "sent"

    @@aiss_mail.send_mail_aiss params[:email][:to],params[:email][:subject],
            params[:email][:body]

    respond_to do |format|
      if @email.save
        format.html { redirect_to emails_url, notice: 'Email enviado' }
        format.json { render json: @email, status: :created, location: @email }
      else
        format.html { render action: "new" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = Email.find(params[:id])

    respond_to do |format|
      if @email.update_attributes(params[:email])
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = Email.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to emails_url }
      format.json { head :no_content }
    end
  end

  def get_all
    UserCredential.retrieve_user_emails
    redirect_to emails_url
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|

      @@username = username
      @@aiss_mail = Aiss::MailAiss.new(username,password)

      login = UserCredential.first
      if (!login)      

        UserCredential.new(:email =>username,
                          :password => password).save
        UserCredential.retrieve_user_emails
      end
      true
    end
  end
end
