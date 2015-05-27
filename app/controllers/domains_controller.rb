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
  end

  def edit
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

private

  def domain_params
    @domain_params ||= params.require(:domain).permit!
  end
  
  def domain_name
    params[:domain_name]
  end
  
end
