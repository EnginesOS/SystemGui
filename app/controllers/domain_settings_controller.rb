class DomainSettingsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_domain_settings, except: :edit

  def edit
    @domain_settings = DomainSettings.load
  end

  def update
    # render text: @domain_settings.qwe
    if @domain_settings.update
      redirect_to domains_path, notice: "Successfully updated domain settings."
    else
      render :new
    end
  end
    

private

  def set_domain_settings
    @domain_settings = DomainSettings.new(domain_settings_params)
  end

  def domain_settings_params
    @domain_settings_params ||= params.require(:domain_settings).permit!
  end
  
end
