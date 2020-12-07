require 'ro_crate_ruby'
require 'toml-rb'

class MdrxProject
  # attr_accessor :toml,:name,:description,:license_id,:license_name,:license_path
  attr_reader :crate

  def initialize(name, description, license_id, license_name, license_path, publisher_id, publisher_name, source_folder_path)
    @name = name
    @description = description
    @license_id = license_id
    @license_name = license_name
    @license_path = license_path
    @publisher_id = publisher_id
    @publisher_name = publisher_name
    @source_folder_path = source_folder_path
    initialise_crate
    @toml = TomlRB.load_file("#{@source_folder_path}/mdrx.toml", symbolize_keys: true)
  end

  def process_manifest()
    @crate.data_entities.clear
    @toml[:manifest].each do |manifest_item|
      if manifest_item.start_with?('include')
        manifest_item_path = manifest_item[8..((manifest_item.length) - 1)]
        path_to_add = @source_folder_path + File::SEPARATOR + manifest_item_path
        crate.add_file(path_to_add, manifest_item_path)
      elsif manifest_item.start_with?('graft') then
        manifest_item_path = manifest_item[6..((manifest_item.length) - 1)]
        folder_to_add = @source_folder_path + File::SEPARATOR + manifest_item_path
        crate.add_directory(folder_to_add,File::SEPARATOR + manifest_item_path)
        Dir.glob("#{folder_to_add}/**/*").each do |file_to_add|
          crate_path = file_to_add.dup
          crate_path["#{@source_folder_path}"] = ''
          crate.add_file(file_to_add, crate_path)
        end
      elsif manifest_item.start_with?('exclude') then
        manifest_item_path = File::SEPARATOR + manifest_item[8..((manifest_item.length) - 1)]
        @crate.data_entities.reject! { |de| de.properties['@id'] == manifest_item_path }
      elsif manifest_item.start_with?('prune') then
        manifest_item_path = manifest_item[6..((manifest_item.length) - 1)]
        path_to_prune = @source_folder_path + File::SEPARATOR + manifest_item_path
        Dir.glob("#{path_to_prune}/**/*").each do |file_to_remove|
          crate_path = file_to_remove.dup
          crate_path["#{@source_folder_path}"] = ''
          @crate.data_entities.reject! { |de| de.properties['@id'] == crate_path }
        end
      end
    end
  end

  def process_annotations
    @toml[:annotations].each do |annotation|
      path_to_be_annotated = File::SEPARATOR + annotation[0].to_s
      puts annotation.inspect
      data_entity_to_be_annotated = @crate.dereference(path_to_be_annotated)
      if data_entity_to_be_annotated == nil
        data_entity_to_be_annotated = @crate.dereference(path_to_be_annotated + File::SEPARATOR)
      end
      annotation_array = []
      existing_annotations = data_entity_to_be_annotated.properties['additionalProperty']
      unless existing_annotations == nil then annotation_array = existing_annotations end
      key_value_hash = annotation[1].values[0]
      annotation_array << {"@type": "PropertyValue", name: key_value_hash[:key], value: key_value_hash[:value]}
      data_entity_to_be_annotated.properties['additionalProperty'] = annotation_array
    end
  end

  private

  def initialise_crate
    extra_root_properties_hash = {}
    @crate = ROCrate::Crate.new
    extra_root_properties_hash['name'] = @name
    extra_root_properties_hash['description'] = @description
    @crate.add_organization(@publisher_id, {name: @publisher_name})
    extra_root_properties_hash['publisher'] = {'@id': @publisher_id}
    @crate.add_contextual_entity(ROCrate::Entity.new(@crate, @license_id, {'@type': 'CreativeWork'}))
    extra_root_properties_hash['license'] = {'@id': @license_id}
    @crate.metadata.properties.update(extra_root_properties_hash)
  end

end