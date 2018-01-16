class ContactsController < ApplicationController

  def index
    json_response(formatted_contacts)
  end

  def show
    contact = Contact.find(params[:id])
    json_response(formatted_contact(contact))
  end

  def create
    new_params = contact_params
    contact = Contact.create(
      first_name: new_params[:name][:first],
      last_name: new_params[:name][:last],
      phone: new_params[:phone],
      email: new_params[:email]
    )
    json_response(formatted_contact(contact), :created)
  end

  def update
    contact = Contact.find(params[:id])
    new_params = contact_params
    contact.update(
      first_name: new_params[:name][:first],
      last_name: new_params[:name][:last],
      phone: new_params[:phone],
      email: new_params[:email]
    )
    head :no_content
  end

  private

  def formatted_contacts
    Contact.all.map do |c|
      formatted_contact(c)
    end
  end

  def formatted_contact(contact)
    {
      _id: contact.id.to_s,
      name: {
        first: contact.first_name,
        last: contact.last_name
      },
      phone: contact.phone,
      email: contact.email
    }
  end

  def contact_params
    params.require(:contact).permit({ name: [:first, :last] }, :phone, :email)
  end
end
