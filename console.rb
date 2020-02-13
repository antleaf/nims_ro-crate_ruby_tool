#!/usr/bin/env ruby
require './lib/config'
require './lib/ro_crate_generator'

LOG.info("Process started")

#### Takes content from one root folder, adds it to second root folder and creates RO-Crate metadata there. Leaves original root folder unaltered.
ROCrateGenerator.generate_ro_crate_in_folder("#{SAMPLE_DATA_FOLDER_PATH}/work1","#{GENERATED_RO_CRATES_FOLDER_PATH}/rocrate1")

#### Takes content from specified root folder, generates RO-Crate metadata and zips up all content + metadata to zip file. Leaves original root folder unaltered.
# ROCrateGenerator.generate_ro_crate_as_zip("#{SAMPLE_DATA_FOLDER_PATH}/work1","#{GENERATED_RO_CRATES_FOLDER_PATH}/rocrate1.zip")

# #### Creates RO-Crate metadata directly in specified root folder.
# #### THIS ONE IS BROKEN THE LIBRARY HAS A BUG - HAVE RAISED ISSUE ON THE RUBY LIBRARY GITHUB
# # ROCrateGenerator.generate_ro_crate_in_folder("#{GENERATED_RO_CRATES_FOLDER_PATH}/work1_with_ro_crate")

LOG.info("Process completed")