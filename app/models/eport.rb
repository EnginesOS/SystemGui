class Eport < ActiveRecord::Base

  attr_accessor(
    :name,
    :internal_port,
    :external_port,
    :tcp,
    :udp)

  belongs_to :install_from_docker_hub

end