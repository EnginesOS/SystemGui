class LibrarySettings < ActiveRecord::Base

  def default_library
    Library.find(default_library_id)
  end

  def self.instance
    first_or_create
  end

end
