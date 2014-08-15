class EngineGallery
  
  #Galleries are to do drawn in from several sources
  #local local of Yaml files  for custom galleries
  #an array of yaml files from a gallery list server for public galleries
  
  
  class GalleryMaintainer
    
    def initialize(name,email,website)
      @name = name
      @email = email
      @website = website      
    end   
  end
  
  def initialize(short_name,title,url,licence,description,maintainer)
    @title = title
    @short_name = short_name
    @blueprints_url = url
    @licence_type = licence #Free | Non Commercial use | Commercial |mixture
    @maintainer =  maintainer
  end

def self.from_yaml( yaml )
      engineGallery = YAML::load( yaml )
      enginegallery
end
    
def EngineGallery.loadLocalGalleries(gallery_file_name)

         if File.exists?(gallery_file_name) == false
           puts("No such configuration:" + gallery_file_name )
           return nil
         end 
         
       gallery_yaml_file = File.open(gallery_file_name) 
       enginegallery = YAML::load( gallery_yaml_file)
      enginegallery
end
     
     
def save
         serialized_object = YAML::dump(self)  
         save_serialized(serialized_object)
end
       
def   save_serialized(serialized_object)
        gallery_dir=SysConfig.galleriesDir + "/" + @short_name
             if File.directory?(gallery_dir) ==false
               Dir.mkdir(gallery_dir)
             end
       gallery_config_filename= galleryDir + "/gallery.yaml"
             
       gallery_config_file = File.new(gallery_config_file,File::CREAT|File::TRUNC|File::RDWR, 0644)
       gallery_config_file.puts(serialized_object)
       gallery_config_file.close
end
         
  def listLocalGalleries
    galleries = Array.new()
    gallery_files = Dir.entries(SysConfig.galleriesDir)
#Fixme should only match yaml files also catch exceptions on bad reads of yaml or file io
    
        gallery_files.each do |gallery_file |
          gallery = EngineGallery.load(gallery_file)
          galleries.push(gallery)
        end
    return galleries
    
  end
  
  def listBluePrints
    #json = get blueprints_url
    
  end
  def getBluePrint id
    
    #json = get blueprints_url + "/" + id
  end
  
  def filter_blueprints types
  end
  
end