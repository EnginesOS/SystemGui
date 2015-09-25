class DomainsController < ApplicationController


  def new
    @domain = Domain.build_new
  end

  def create
    @domain = Domain.new(domain_params)
    if @domain.create
      redirect_to domains_manager_path, notice: "Successfully created #{domain_name}."
    else
      render :new
    end
  end

  def edit
    @domain = Domain.build_edit_for domain_name
  end

  def update
    @domain = Domain.new(domain_params)
    if @domain.update
      redirect_to domains_manager_path, notice: "Successfully updated #{domain_name}."
    else
      render :edit
    end
  end

  def destroy
    @domain = Domain.new(domain_name: domain_name)
    if @domain.destroy
      redirect_to domains_manager_path, notice: "Successfully deleted #{domain_name}."
    else
      redirect_to domains_manager_path, alert: "Unable to delete #{domain_name}."
    end
  end

private

  def domain_params
    p = params.require(:domain).permit!
    if p[:self_hosted] == "0"
      p[:internal_only] = "0"
    end
    p
  end
  
  def domain_name
    params[:domain_name] || domain_params[:domain_name]
  end
  
end
