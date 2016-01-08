class InstallersController < ApplicationController

  def show
    default_domain = DomainDefaultName.engines_default_domain
    if default_domain.empty? || default_domain == 'unset'
      redirect_to control_panel_path, alert: "Please set a default domain before installing software." 
    else
      @library = Library.find(library_id)
      @other_libraries = Library.where.not(id: library_id)
      params[:tags] = ( (params[:commit] == 'All' || params[:tags].blank?) ? 'All' : params[:tags] )
    end
  end

  def library_id
    params[:library_id] || ( LibrarySettings.instance.default_library || Library.first ).id
  end

end
