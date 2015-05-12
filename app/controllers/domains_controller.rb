class DomainsController < ApplicationController

  before_action :authenticate_user!

  # include EnginesDomainsActions
# 
  # before_action :set_settings, only: [:edit_default_domain, :edit_default_website, :update_network_settings]

  # before_action :set_domain, only: [:edit, :update, :destroy]
  # before_action :new_domain, only: [:new, :create]

  def index
    # render text: Domain.domain_names_list
    @domain_settings = DomainSettings.load
    @domains = Domain.load_all
  end

  def new
    @domain = Domain.new
    # render text: @domain.new_record?
  end

  def edit
    # render text: @domain.original_domain_name
    @domain = Domain.load domain_name
  end

  def update
    @domain = Domain.new(domain_params.merge(original_domain_name: domain_name))
    if @domain.update
      redirect_to domains_path, notice: "Successfully updated #{domain_name}."
    else
      render :new
    end
  end

  def create
    @domain = Domain.new(domain_params)
    if @domain.create
      redirect_to domains_path, notice: "Successfully created #{domain_name}."
    else
      render :new
    end
  end

  def destroy
    @domain = Domain.load domain_name
    if @domain.destroy
      redirect_to domains_path, notice: "Successfully deleted #{domain_name}."
    else
      redirect_to domains_path, alert: "Unable to delete #{domain_name}."
    end
  end

# private

  # def set_domain
    # @domain = Domain.new key: params[:id]
  # end
# 
  # # def new_domain
    # # @domain = Domain.new
  # # end
# 
# 
  # # def set_settings
    # # @settings = Setting.first_or_create
  # # end
# 
  def domain_params
    @domain_params ||= params.require(:domain).permit!
  end
  
  def domain_name
    Domain.key_to_domain_name(params[:domain_name])
  end
  
#   
  # def domain_key
    # Domain.key_from_domain_name params[:domain][:domain_name]
  # end

  # def settings_params
    # params.require(:setting).permit!
  # end
  
end
