# Define the browser name for easier modification
browser_name="GTx Browser"
out_dir="out/gtx"

# Clone the necessary repositories
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ~/depot_tools --depth=1
grep -qxF 'export PATH="$PATH:${HOME}/depot_tools"' ~/.bashrc || echo 'export PATH="$PATH:${HOME}/depot_tools"' >> ~/.bashrc
source ~/.bashrc

os_name="$(uname)"

# System-specific setup
if [ "$os_name" = "Darwin" ]; then
    sudo ln -s /usr/bin/python3 /usr/local/bin/python
elif [ "$os_name" = "Linux" ]; then
    ./build/install-build-deps.sh
else
    echo "Unsupported operating system: $os_name . Exiting without installing."
    exit 1
fi

# Set up gclient
cat <<EOL > ../.gclient
solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "managed": False,
    "custom_deps": {},
    "custom_vars": {
        "checkout_pgo_profiles": True,
    },
  },
]
EOL

# Sync and run hooks
gclient sync
gclient runhooks

# Build and setup based on OS
if [ "$os_name" = "Darwin" ]; then
    gn gen "${out_dir}" --args="treat_warnings_as_errors = false is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true"
    caffeinate autoninja -C "${out_dir}" chrome

    # Define the extensions directory
    EXTENSIONS_DIR="${out_dir}/${browser_name}.app/Contents/Frameworks/${browser_name} Framework.framework/Versions/Current/extensions"
    mkdir -p "${EXTENSIONS_DIR}"
    cp -r chrome/browser/extensions/default_extensions/* "${EXTENSIONS_DIR}/"

    "${out_dir}/${browser_name}.app/Contents/MacOS/${browser_name}" --enable-logging=stderr --v=0
elif [ "$os_name" = "Linux" ]; then
    gn gen "${out_dir}" --args="treat_warnings_as_errors = false enable_linux_installer = true is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true"
    autoninja -C "${out_dir}" chrome
    cp "${out_dir}/chrome_sandbox.stripped" "${out_dir}/gtxbrowser_sandbox.stripped"
    cp -r chrome/browser/extensions/default_extensions "${out_dir}/extensions"
    "${out_dir}/gtxbrowser" --enable-logging=stderr --v=0 --disable-gpu
else
    echo "Unsupported operating system: $os_name . Exiting without installing."
    exit 1
fi
