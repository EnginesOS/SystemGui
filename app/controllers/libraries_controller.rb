class LibrariesController < ApplicationController

  def index
    @library_settings = LibrarySettings.instance
    @libraries = Library.all
  end

  def new
    @library = Library.new
  end

  def edit
    @library = Library.find(params[:id])
  end

  def update
    @library = Library.find(params[:id])
    @library.update(library_install_params)
    redirect_to libraries_path
  end

  def create
    @library = Library.new(library_install_params)
    if @library.save
      redirect_to libraries_path
    else
      render :new
    end
  end

  def destroy
    @library = Library.find(params[:id])
    @library.destroy
    redirect_to libraries_path
  end

private

  def library_install_params
    params.require(:library).permit!
  end

end
