require 'nokogiri'
require './lib/ro-crate-ruby/lib/ro_crate_ruby'

class ROCrateGenerator

  def self.create_ro_crate_from_folder(input_folder_path)
    crate = ROCrate::Crate.new
    begin
      Dir.chdir(input_folder_path) do
        Dir.glob("**/*").each do |path|
          if File.file?(path)
            crate.add_file(path,path)
            LOG.debug("Added file with path '#{path}' to RO-Crate")
          elsif File.directory?(path)
            crate.add_directory(path,path)
            LOG.debug("Added directory with path '#{path}' to RO-Crate")
          end
        end
      end
    rescue StandardError => e
      LOG.error(e)
    end
    return crate
  end

  def self.create_html_preview(crate,folder_path)
    # @doc = Nokogiri::HTML('<!doctype html><html><head><meta charset="utf-8"/></head><body></body></html>')
    # File.open("#{folder_path}/ro-crate-preview.html",'w') do |f|
    #   f.write(@doc.to_html)
    # end
  end



  def self.generate_ro_crate_in_folder(input_folder,target_folder=nil)
    if target_folder == nil
      target_folder = input_folder
      LOG.debug("Generating RO-Crate metadata in situ in folder with path: '#{target_folder}'....")
    end
    begin
      crate = self.create_ro_crate_from_folder(input_folder)
      ROCrate::Writer.new(crate).write(target_folder)
      # self.create_html_preview(crate,target_folder)
      LOG.info("Wrote RO-Crate metadata to folder with path: '#{target_folder}'")
    rescue StandardError => e
      LOG.error(e)
    end
  end

  def self.generate_ro_crate_as_zip(input_folder,zip_file_path)
    begin
      crate = self.create_ro_crate_from_folder(input_folder)
      ROCrate::Writer.new(crate).write_zip(File.new(zip_file_path, 'w'))
      # self.create_html_preview(crate,target_folder)
      LOG.info("Wrote RO-Crate metadata to zip file with path: '#{zip_file_path}'")
    rescue StandardError => e
      LOG.error(e)
    end
  end

end