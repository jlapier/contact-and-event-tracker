class ContactRevisionsController < ApplicationController
  def index
    if params[:id]
      @contact_revision = ContactRevision.find params[:id]
      redirect_to @contact_revision
    end
  end

  def show
    @contact_revision = ContactRevision.find params[:id]
  end
end