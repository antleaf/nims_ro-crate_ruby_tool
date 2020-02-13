# NIMS RO-Crate Ruby Utility

Just code to help experiment with RO-Crate for the NIMS MDR/MDR-X projects.

This utility has a dependency on `[ro-crate-ruby](https://github.com/fbacall/ro-crate-ruby)` which is included as a git submodule in this project.

## Instructions
1. From within this repository, on the comman line, run:
   `git submodule update --init --recursive`
2. Copy or move `./config/config_SAMPLE.yaml` to `./config/config.yaml`
3. Edit `./config/config.yaml`:
  1. set `sample_data_folder_path:` to the path to a sample data folder on your local filesystem
  2. set `generated_ro_crates_folder_path:`to the path to an empty folder on your local filesystem
4. Examine the three examples in `./console.rb` and experiment with them! This file is designed to be run from the command-line. You will need to change the paths as appropriate to our local folders

