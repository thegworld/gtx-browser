#!/bin/bash

# Define the browser name and output directory
browser_name="GTx Browser"
out_dir="out/intel"

# Generate the build
gn gen "${out_dir}" --args="enable_widevine=true treat_warnings_as_errors = false is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true target_cpu=\"x64\"" && caffeinate autoninja -C "${out_dir}" chrome 

# Define base directories
BASE_OUT_DIR="${out_dir}/${browser_name}.app/Contents"
FRAMEWORK_BASE_DIR="${BASE_OUT_DIR}/Frameworks/${browser_name} Framework.framework/Versions"

# Use wildcard to get the version directory. Assumes there's only one directory under Versions.
VERSION_DIR=$(ls "${FRAMEWORK_BASE_DIR}" | head -n 1)
EXTENSIONS_DIR="${FRAMEWORK_BASE_DIR}/${VERSION_DIR}/extensions"

# Create the directory if it doesn't exist
mkdir -p "${EXTENSIONS_DIR}"

# Copy the extensions
cp -r chrome/browser/extensions/default_extensions/* "${EXTENSIONS_DIR}/"

# Run the browser
"${BASE_OUT_DIR}/MacOS/${browser_name}" --enable-logging=stderr --v=0
