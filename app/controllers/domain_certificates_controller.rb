class DomainCertificatesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_domain_certificate
  
  def show
  end
  
  def new
  end

  def create
    if @domain_certificate.create domain_certificate_params
      redirect_to domain_certificate_path(domain_name: domain_key), notice: "Successfully created a new certificate for #{domain_name}."
    else
      render :new
    end
  end

  private

  def set_domain_certificate
    @domain_certificate = DomainCertificate.load domain_key
  end

  def domain_key
    params[:domain_name]
  end
  
  def domain_name
    Domain.key_to_domain_name domain_key
  end

  def domain_certificate_params
    params.require(:domain_certificate).permit!
  end

end
