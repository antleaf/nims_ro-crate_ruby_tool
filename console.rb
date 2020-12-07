#!/usr/bin/env ruby
require 'ro_crate_ruby'
require 'toml-rb'
require './mdrx'
require 'fileutils'

$source_folder_path = '../mdrx_sample_data_git' # change this for your own folder containing a cloned MDR-X compatible git repo

mdrx = MdrxProject.new(
    'TestProject1 ',
    'A utility for generating RDF from the Web documentation of the DCMI vocabularies',
    'http://www.apache.org/licenses/LICENSE-2.0',
    'Apache License 2.0',
    './LICENSE',
    'https://ror.org/026v1ze26',
    'National Institute for Materials Science',
    $source_folder_path
)

mdrx.process_manifest
mdrx.process_annotations

# write RO-Crate
output_folder_path = './data/output'
FileUtils.rm_rf(Dir.glob("#{output_folder_path}/*"))
ROCrate::Writer.new(mdrx.crate).write(output_folder_path)

