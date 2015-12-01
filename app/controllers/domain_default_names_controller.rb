class DomainDefaultNamesController < ApplicationController

  def edit
    @domain_default_name = DomainDefaultName.load
  end

  def update
    @domain_default_name = DomainDefaultName.new(domain_default_name_params)
    if @domain_default_name.update
      redirect_to domains_manager_path, notice: "Successfully updated default domain."
    else
      render :edit
    end
  end

private

  def domain_default_name_params
    @domain_default_name_params ||= params.require(:domain_default_name).permit!
  end
  
end
