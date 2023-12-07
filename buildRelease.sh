os_name="$(uname)"

# Define the browser name and output directory
browser_name="GTx Browser"
out_dir="out/gtx"

if [ "$os_name" = "Darwin" ]; then
    # macOS
    
    # Generate the build 
    # gn gen "${out_dir}" --args="enable_widevine=true treat_warnings_as_errors = false is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true" && caffeinate autoninja -C "${out_dir}" chrome 

    #Mac build by James Arguments
    gn gen "${out_dir}" --args="symbol_level=0 treat_warnings_as_errors=false chrome_pgo_phase=0 ffmpeg_branding=\"Chrome\" is_clang=true is_component_build=false is_debug=false proprietary_codecs=true use_gnome_keyring=false use_sysroot=false is_official_build=true enable_widevine=true"  && caffeinate autoninja -C "${out_dir}" chrome 

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

elif [ "$os_name" = "Linux" ]; then
    # Linux
    gn gen "${out_dir}" --args="enable_widevine=true treat_warnings_as_errors = false enable_linux_installer = true is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true" 
    autoninja -C "${out_dir}" chrome 
    EXTENSIONS_DIR="${out_dir}/extensions"
    mkdir -p "${EXTENSIONS_DIR}"
    cp -r chrome/browser/extensions/default_extensions/* "${EXTENSIONS_DIR}/"
    cp "${out_dir}/chrome_sandbox.stripped" "${out_dir}/gtxbrowser_sandbox.stripped"
    "${out_dir}/gtxbrowser" --enable-logging=stderr --v=0 --disable-gpu
    autoninja -C "${out_dir}" "chrome/installer/linux:stable_deb"

else
    echo "Unsupported operating system: $os_name . Exiting without installing."
    exit 1
fi
