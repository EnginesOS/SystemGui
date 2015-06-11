class Eport < ActiveRecord::Base

  attr_accessor(
    :name,
    :internal_port,
    :external_port,
    :tcp,
    :udp)

  belongs_to :docker_hub_installation

end