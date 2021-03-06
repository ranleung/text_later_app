class ContactsController < ApplicationController

  def index
    find_user_id
    if session[:user_id] == @user.id
      session_id = session[ :user_id ]
      route_id   = params[ :user_id ]

      if session_id.to_i == route_id.to_i
        user_id = params[:user_id]
        @user = User.find_by_id(user_id)
        @contacts = @user.contacts.all
        user_name
      end

      respond_to do |format|
        format.html
        format.json { render json: @contacts}
      end
    else
      redirect_to '/'
    end

  end

  def new
    find_user_id
    if session[:user_id] == @user.id
      session_id = session[ :user_id ]
      route_id   = params[ :user_id ]

      if session_id.to_i == route_id.to_i
        user_id = params[:user_id]
        @user = User.find_by_id(user_id)
        @contact = @user.contacts.new
        user_name
      else
        redirect_to user_contacts_path(session_id)
      end
    else
      redirect_to '/'
    end
    
  end

  def show
    session_id = session[ :user_id ]
    route_id   = params[ :user_id ]
    
    if session_id.to_i == route_id.to_i   
      find_user_id
      contact_id = params[:id]
      @contact = @user.contacts.find(contact_id)
      user_name
    else
      redirect_to user_contacts_path(session_id) 
    end
  end

  def create
    session_id = session[ :user_id ]
    route_id   = params[ :user_id ]
    
    if session_id.to_i == route_id.to_i
      find_user_id

      new_contact = params[:contact].permit(:first_name, :last_name, :phone_num)
      @contact = @user.contacts.create(new_contact)
    end
    redirect_to user_contacts_path(session_id), notice: "Contact Added!"
  end


  def edit
    session_id = session[ :user_id ]
    route_id   = params[ :user_id ]
    
    if session_id.to_i == route_id.to_i
      find_user_id
      find_contact
      user_name
    else
      redirect_to user_contacts_path(session_id)
    end  

  end

  def update
    session_id = session[ :user_id ]
    route_id   = params[ :user_id ]
    
    if session_id.to_i == route_id.to_i
      find_user_id
      find_contact
      # binding.pry
      updateContact = params.require(:contact).permit(:first_name, :last_name, :phone_num)
      # binding.pry
      @contact.update_attributes(first_name: updateContact[:first_name], last_name: updateContact[:last_name], phone_num: updateContact[:phone_num])

      redirect_to user_contacts_path, :notice => "Contact Updated!"
    else
      redirect_to user_contacts_path(session_id)
    end
  	
  end

  def destroy
    session_id = session[ :user_id ]
    route_id   = params[ :user_id ]
    
    if session_id.to_i == route_id.to_i
      find_user_id
      find_contact
      @contact.destroy

      redirect_to user_contacts_path, :notice => "Contact Deleted!"
    else
      redirect_to user_contacts_path(session_id)
    end   
  end

  private

  def find_user_id
    p params 
    user_id = params[:user_id]
    @user = User.find_by_id(user_id)
  end

  def find_contact
    contact_id = params[:id]
    @contact = Contact.find_by_id(contact_id)
  end

end
