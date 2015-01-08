class DomainsController < ApplicationController

  include EnginesDomainsActions

  before_action :authenticate_user!

  def index
    @domains = Domain.all.sort_by{|d| d.domain_name}
  end

  def new
    @domain = Domain.new
  end

  def edit
    @domain = Domain.find(params[:id])
  end

  def update
    @domain = Domain.find(params[:id])
    @domain.update(domain_params)
    @domain.update_via_api
    redirect_to domains_path
  end

  def create
    @domain = Domain.new(domain_params)
    if !@domain.save
      render :new
    elsif !@domain.save_via_api
      @domain.delete
      render :new, alert: 'Unable to save self-hosted domain.'
    else
      redirect_to domains_path, notice: 'Successfully created self-hosted domain.'

    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy_via_api
    redirect_to domains_path
  end

private

  def domain_params
    params.require(:domain).permit!
  end

end
