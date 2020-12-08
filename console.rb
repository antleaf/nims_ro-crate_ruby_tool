#!/usr/bin/env ruby
require 'ro_crate_ruby'
require 'toml-rb'
require 'fileutils'
require './lib/config'
require './lib/mdrx'

LOG.info("Starting....")


mdrx = MdrxProject.new(
    'TestProject1 ',
    'A utility for generating RDF from the Web documentation of the DCMI vocabularies',
    'http://www.apache.org/licenses/LICENSE-2.0',
    'Apache License 2.0',
    './LICENSE',
    'https://ror.org/026v1ze26',
    'National Institute for Materials Science',
    SOURCE_FOLDER_PATH,
    HTML_TEMPLATE_PATH
)

LOG.info("Starting....")
mdrx.process_manifest
mdrx.process_annotations

# write RO-Crate
FileUtils.rm_rf(Dir.glob("#{OUTPUT_FOLDER_PATH}/*"))
ROCrate::Writer.new(mdrx.crate).write(OUTPUT_FOLDER_PATH)
LOG.info("Uncompressed RO-Crate written to #{OUTPUT_FOLDER_PATH}")

LOG.info("Completed")