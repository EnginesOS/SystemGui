class Eport < ActiveRecord::Base

  attr_accessor(
    :name,
    :internal_port,
    :external_port,
    :protocol)

  belongs_to :install_from_docker_hub
  
  enum protocol: [ 'TCP', 'UDP', 'TCP and UDP']

  validates :name, presence: true

end