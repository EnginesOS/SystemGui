class LibrarySettings < ActiveRecord::Base

  def default_library
    default_library_id ? Library.find(default_library_id) : Library.first
  end

  def self.instance
    first_or_create
  end

end