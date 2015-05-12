module EnginesDomainsSystemActions

  def new_ssl_certificate
    @domain = Domain.find(params[:id])
  end

  def create_ssl_certificate
    EnginesDomain.create_ssl_certificate ssl_certificate_params
    redirect_to domains_path
  end

private

  def ssl_certificate_params
    params.require(:domain).permit!
  end

end