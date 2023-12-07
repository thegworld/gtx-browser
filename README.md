# ![Logo](chrome/app/theme/chromium/product_logo_64.png) GTx BROWSER

## Simplified Instructions
1: on Windows 11 install Visual Studio 2022 x64 and Visual Studio 2019 x64 then install depot_tools and set all paths in environment variables as well as DEPOT_TOOLS_WIN_TOOLCHAIN=0 variable and other environment variables with below instructions (under Setting up Windows tag). for Mac: Xcode 14.5 on MacOS Ventutra OS and goto to step 5. for Linux use Ubuntu 22 OS and goto to step 5

2: install depot_tools with instruction below.

3: make sure depot_tools/python.bat is first in response of 
```
where python
C:\depot_tools\python.bat
```
4: create new folder named gtx-browser 

5: open cmd in that gtx-browser folder then copy code from [get-code-and-build.bat](https://github.com/J-Gworld/gtx-browser/blob/main/get-code-and-build.bat) for Windows or  [get-code-and-build.sh](https://github.com/J-Gworld/gtx-browser/blob/main/get-code-and-build.sh) for Mac\Linux and run it in cmd. if you want to download whole git history you can remove --depth=1 from those commands

6: if it fails copy code from [fix-build.bat](https://github.com/J-Gworld/gtx-browser/blob/main/fix-build.bat) or [fix-build.sh](https://github.com/J-Gworld/gtx-browser/blob/main/fix-build.sh) for Mac\Linux and run it

7: after modifying browser run code from [buildRelease.bat](https://github.com/J-Gworld/gtx-browser/blob/main/buildRelease.bat)

it will download and build the code and browser will open after build when build is successful.


## System requirements

* A 64-bit Intel machine with at least 8GB of RAM. More than 16GB is highly
  recommended.
* At least 100GB of free disk space on an NTFS-formatted hard drive. FAT32
  will not work, as some of the Git packfiles are larger than 4GB.
* An appropriate version of Visual Studio, as described below.
* Windows 10 or newer.

## Setting up Windows

### Visual Studio

Chromium requires [Visual Studio 2019](https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes) (>=16.0.0)
to build, but [Visual Studio 2022](https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-notes) (>=17.0.0)
is preferred. Visual Studio can also be used to debug Chromium, and version 2022 is
preferred for this as it handles Chromium's large debug information much better.
The clang-cl compiler is used but Visual Studio's header files, libraries, and
some tools are required. Visual Studio Community Edition should work if its
license is appropriate for you. You must install the "Desktop development with
C++" component and the "MFC/ATL support" sub-components. This can be done from
the command line by passing these arguments to the Visual Studio installer (see
below for ARM64 instructions):
```shell
$ PATH_TO_INSTALLER.EXE ^
--add Microsoft.VisualStudio.Workload.NativeDesktop ^
--add Microsoft.VisualStudio.Component.VC.ATLMFC ^
--includeRecommended
```

If you want to build for ARM64 Win32 then some extra arguments are needed. The
full set for that case is:
```shell
$ PATH_TO_INSTALLER.EXE ^
--add Microsoft.VisualStudio.Workload.NativeDesktop ^
--add Microsoft.VisualStudio.Component.VC.ATLMFC ^
--add Microsoft.VisualStudio.Component.VC.Tools.ARM64 ^
--add Microsoft.VisualStudio.Component.VC.MFC.ARM64 ^
--includeRecommended
```

-You must have the version 10.0.20348.0 [Windows 10 SDK](https://developer.microsoft.com/en-us/windows/downloads/sdk-archive/)
installed. I also have 10.0.22000.0 and 10.0.22621.0 installed. This can be installed separately or by checking the appropriate box
in the Visual Studio Installer.

The SDK Debugging Tools must also be installed. If the Windows 10 SDK was
installed via the Visual Studio installer, then they can be installed by going
to: Control Panel → Programs → Programs and Features → Select the "Windows
Software Development Kit" → Change → Change → Check "Debugging Tools For
Windows" → Change. Or, you can download the standalone SDK installer and use it
to install the Debugging Tools.

## Install `depot_tools`

Download the [depot_tools bundle](https://storage.googleapis.com/chrome-infra/depot_tools.zip)
and extract it somewhere (eg: C:\src\depot_tools).

*** note
**Warning:** **DO NOT** use drag-n-drop or copy-n-paste extract from Explorer,
this will not extract the hidden “.git” folder which is necessary for
depot_tools to autoupdate itself. You can use “Extract all…” from the
context menu though.
***

Add depot_tools to the start of your PATH (must be ahead of any installs of
Python. Note that environment variable names are case insensitive).

Assuming you unzipped the bundle to C:\src\depot_tools, open:

Control Panel → System and Security → System → Advanced system settings

If you have Administrator access, Modify the PATH system variable and
put `C:\src\depot_tools` at the front (or at least in front of any directory
that might already have a copy of Python or Git).

If you don't have Administrator access, you can add a user-level PATH
environment variable by opening:

Control Panel → System and Security → System → Search for "Edit environment variables for your account"

Add `C:\src\depot_tools` at the front. Note: If your system PATH has a Python in it, you will be out of luck.

Also, add a DEPOT_TOOLS_WIN_TOOLCHAIN environment variable in the same way, and set
it to 0. This tells depot_tools to use your locally installed version of Visual
Studio (by default, depot_tools will try to use a google-internal version).

You may also have to set variable `vs2022_install` or `vs2019_install` or
`vs2022_install` to your installation path of Visual Studio 2022 or 19, like
`set vs2019_install=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional`
for Visual Studio 2019, or
`set vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Professional`
for Visual Studio 2022.

From a cmd.exe shell, run:

```shell
$ gclient
```

On first run, gclient will install all the Windows-specific bits needed to work
with the code, including msysgit and python.

* If you run gclient from a non-cmd shell (e.g., cygwin, PowerShell),
  it may appear to run properly, but msysgit, python, and other tools
  may not get installed correctly.
* If you see strange errors with the file system on the first run of gclient,
  you may want to [disable Windows Indexing](https://tortoisesvn.net/faq.html#cantmove2).

## Check python install

After running gclient open a command prompt and type `where python` and
confirm that the depot_tools `python.bat` comes ahead of any copies of
python.exe. Failing to ensure this can lead to overbuilding when
using gn - see [crbug.com/611087](https://crbug.com/611087).

[App Execution Aliases](https://docs.microsoft.com/en-us/windows/apps/desktop/modernize/desktop-to-uwp-extensions#alias)
can conflict with other installations of python on the system so disable
these for 'python.exe' and 'python3.exe' by opening 'App execution aliases'
section of Control Panel and unticking the boxes next to both of these
that point to 'App Installer'.


## Get the code

First, clone gtx-browser repository (https://github.com/J-Gworld/gtx-browser.git) in directory where you want to implement project(ex. "D://gtxbrowser").

## create .gclient file

```shell
$ mkdir gtx-browser && cd gtx-browser && mkdir src && cd src
```
now to clone this repo
```shell
$ git clone https://github.com/J-Gworld/gtx-browser.git .
# OR to get main branch directly 
$ git clone -b main https://github.com/J-Gworld/gtx-browser.git .
# OR if you want to get no history for faster download (equals to fetch --no-history option of chromium)
$ git clone -b main --depth=1 https://github.com/J-Gworld/gtx-browser.git .
```


## sync repos & Install 

- For windows
```shell
$ fix-build.bat
```

- For Linux
these commands are working on ubuntu 20.04. these will also setup dev environment for you.
```shell
$ sudo apt install python-is-python3
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git  ~/depot_tools --depth=1
$ echo 'export PATH="$PATH:${HOME}/depot_tools"' >> ~/.bashrc
$ source ~/.bashrc
$ ./build/install-build-deps.sh
$ sh fix-build.sh
```

- For Mac OS
these commands are working on MacOS Big Sur (11.6) and XCode 12.4. these will also setup dev environment for you.
```shell
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git  ~/depot_tools --depth=1
$ echo 'export PATH="$PATH:${HOME}/depot_tools"' >> ~/.bashrc
$ source ~/.bashrc
$ sudo ln -s /usr/bin/python3 /usr/local/bin/python
$ sh fix-build.sh
```

## Wallet Extension Update
Obtain the wallet crx from the developer or build your own and pack with a key.
When you get the crx you place it inside `gtx-browser\src\chrome\browser\extensions\default_extensions\extension.crx`.
Load the crx file in chrome to get the extension ID. Replace all instances of the previous wallet extension ID "aggbbnpplelcpkdahdnmoogmgnopikhk" with the new one.

## Mac Apple Signing Certificate:
you need to get a apple developer paid account then go to certificate on website
then create signing request in keychain app, [upload the file on apple, download crt from apple](https://developer.apple.com/help/account/create-certificates/create-developer-id-certificates/) 

```shell
 security create-keychain "$HOME/Library/Keychains/logingtx114.keychain-db" 
 security unlock-keychain ~/Library/Keychains/logingtx114.keychain-db
#  you need to replace the APPLE_APP_SPECIFIC_PASSWORD with apple app specific password
 xcrun notarytool store-credentials --keychain "~/Library/Keychains/logingtx114.keychain-db" --apple-id "{your-apple-id}" --team-id "{your-team-id}" --password "APPLE_APP_SPECIFIC_PASSWORD" "Developer ID Application: {your-name} ({your-team-id})"
 
 security find-certificate -c "{your-cert-name}" -p | openssl x509 -inform pem -noout -subject
 
 pwd
# open sign.sh in text editor and change the details that is different. 
#you must change location of BUILDROOT, & maybe ID, browser_name
 nano ./chrome/installer/mac/Chromium-Mac-Signing-Alignment-Notarization-DMG/sign.sh
# then run script
 sh ./chrome/installer/mac/Chromium-Mac-Signing-Alignment-Notarization-DMG/sign.sh

# make dmg and sign and notorise it
 npm i -g create-dmg
 create-dmg out/gtx/GTx\ Browser.app out/gtx 
 xcrun notarytool submit --wait --keychain "~/Library/Keychains/logingtx114.keychain-db" --keychain-profile "Developer ID Application: {your-name} ({your-team-id})" out/gtx/GTx\ Browser\ 114.0.5735.199.dmg

```
if the output is successful then you can upload the dmg to your website release page or send anyone

## Setting up the build

Chromium uses [Ninja](https://ninja-build.org) as its main build tool along with
a tool called [GN](https://gn.googlesource.com/gn/+/main/docs/quick_start.md)
to generate `.ninja` files. You can create any number of *build directories*
with different configurations. To create a build directory:

```shell
gn gen out\gtx --args="treat_warnings_as_errors = false is_debug=false dcheck_always_on=false blink_symbol_level=0 symbol_level=0 proprietary_codecs=true ffmpeg_branding=\"Chrome\" is_official_build=true"
```

* You only have to run this once for each new build directory, Ninja will
  update the build files as needed.
* You can replace `gtx` with another name, but
  it should be a subdirectory of `out`.
* For other build arguments, including release settings or using an alternate
  version of Visual Studio, see [GN build
  configuration](https://www.chromium.org/developers/gn-build-configuration).
  The default will be a debug component build matching the current host
  operating system and CPU.
* For more info on GN, run `gn help` on the command line or read the [quick
  start guide](https://gn.googlesource.com/gn/+/main/docs/quick_start.md).

### Faster builds

* Reduce file system overhead by excluding build directories from
  antivirus and indexing software.
* Store the build tree on a fast disk (preferably SSD).
* The more cores the better (20+ is not excessive) and lots of RAM is needed
(64 GB is not excessive).

There are some gn flags that can improve build speeds. You can specify these
in the editor that appears when you create your output directory
(`gn args out/gtx`) or on the gn gen command line
(`gn gen out/gtx--args="is_component_build = true is_debug = true"`).
Some helpful settings to consider using include:
* `is_component_build = true` - this uses more, smaller DLLs, and incremental
linking.
* `enable_nacl = false` - this disables Native Client which is usually not
needed for local builds.
* `target_cpu = "x86"` - x86 builds are slightly faster than x64 builds and
support incremental linking for more targets. Note that if you set this but
don't' set enable_nacl = false then build times may get worse.
* `blink_symbol_level = 0` - turn off source-level debugging for
blink to reduce build times, appropriate if you don't plan to debug blink.
* `v8_symbol_level = 0` - turn off source-level debugging for v8 to reduce
build times, appropriate if you don't plan to debug v8.

In order to speed up linking you can set `symbol_level = 1` or
`symbol_level = 0` - these options reduce the work the compiler and linker have
to do. With `symbol_level = 1` the compiler emits file name and line number
information so you can still do source-level debugging but there will be no
local variable or type information. With `symbol_level = 0` there is no
source-level debugging but call stacks still have function names. Changing
`symbol_level` requires recompiling everything.

In addition, Google employees should use goma, a distributed compilation system.
Detailed information is available internally but the relevant gn arg is:
* `use_goma = true`

To get any benefit from goma it is important to pass a large -j value to ninja.
A good default is 10\*numCores to 20\*numCores. If you run autoninja then it
will automatically pass an appropriate -j value to ninja for goma or not.

```shell
autoninja -C out\gtx chrome
```

When invoking ninja specify 'chrome' as the target to avoid building all test
binaries as well.

Still, builds will take many hours on many machines.


### Why is my build slow?

Many things can make builds slow, with Windows Defender slowing process startups
being a frequent culprit. Have you ensured that the entire Chromium src
directory is excluded from antivirus scanning (on Google machines this means
putting it in a ``src`` directory in the root of a drive)? Have you tried the
different settings listed above, including different link settings and -j
values? Have you asked on the chromium-dev mailing list to see if your build is
slower than expected for your machine's specifications?

The next step is to gather some data. If you set the ``NINJA_SUMMARIZE_BUILD``
environment variable to 1 then ``autoninja`` will do three things. First, it
will set the [NINJA_STATUS](https://ninja-build.org/manual.html#_environment_variables)
environment variable so that ninja will print additional information while
building Chrome. It will show how many build processes are running at any given
time, how many build steps have completed, how many build steps have completed
per second, and how long the build has been running, as shown here:

```shell
$ set NINJA_SUMMARIZE_BUILD=1
$ autoninja -C out\gtx base
ninja: Entering directory `out\gtx'
[1 processes, 86/86 @ 2.7/s : 31.785s ] LINK(DLL) base.dll base.dll.lib base.dll.pdb
```

This makes slow process creation immediately obvious and lets you tell quickly
if a build is running more slowly than normal.

In addition, setting ``NINJA_SUMMARIZE_BUILD=1`` tells ``autoninja`` to print a
build performance summary when the build completes, showing the slowest build
steps and slowest build-step types, as shown here:

```shell
$ set NINJA_SUMMARIZE_BUILD=1
$ autoninja -C out\gtx base
Longest build steps:
       0.1 weighted s to build obj/base/base/trace_log.obj (6.7 s elapsed time)
       0.2 weighted s to build nasm.exe, nasm.exe.pdb (0.2 s elapsed time)
       0.3 weighted s to build obj/base/base/win_util.obj (12.4 s elapsed time)
       1.2 weighted s to build base.dll, base.dll.lib (1.2 s elapsed time)
Time by build-step type:
       0.0 s weighted time to generate 6 .lib files (0.3 s elapsed time sum)
       0.1 s weighted time to generate 25 .stamp files (1.2 s elapsed time sum)
       0.2 s weighted time to generate 20 .o files (2.8 s elapsed time sum)
       1.7 s weighted time to generate 4 PEFile (linking) files (2.0 s elapsed
time sum)
      23.9 s weighted time to generate 770 .obj files (974.8 s elapsed time sum)
26.1 s weighted time (982.9 s elapsed time sum, 37.7x parallelism)
839 build steps completed, average of 32.17/s
```

The "weighted" time is the elapsed time of each build step divided by the number
of tasks that were running in parallel. This makes it an excellent approximation
of how "important" a slow step was. A link that is entirely or mostly serialized
will have a weighted time that is the same or similar to its elapsed time. A
compile that runs in parallel with 999 other compiles will have a weighted time
that is tiny.

You can also generate these reports by manually running the script after a build:

```shell
$ python depot_tools\post_build_ninja_summary.py -C out\gtx
```

Finally, setting ``NINJA_SUMMARIZE_BUILD=1`` tells autoninja to tell Ninja to
report on its own overhead by passing "-d stats". This can be helpful if, for
instance, process creation (which shows up in the StartEdge metric) is making
builds slow, perhaps due to antivirus interference due to clang-cl not being in
an excluded directory:

```shell
$ set NINJA_SUMMARIZE_BUILD=1
$ autoninja -C out\gtx base
"c:\src\depot_tools\ninja.exe" -C out\gtx base -d stats
metric                  count   avg (us)        total (ms)
.ninja parse            3555    1539.4          5472.6
canonicalize str        1383032 0.0             12.7
canonicalize path       1402349 0.0             11.2
lookup node             1398245 0.0             8.1
.ninja_log load         2       118.0           0.2
.ninja_deps load        2       67.5            0.1
node stat               2516    29.6            74.4
depfile load            2       1132.0          2.3
StartEdge               88      3508.1          308.7
FinishCommand           87      1670.9          145.4
CLParser::Parse         45      1889.1          85.0
```

You can also get a visual report of the build performance with
[ninjatracing](https://github.com/nico/ninjatracing). This converts the
.ninja_log file into a .json file which can be loaded into chrome://tracing:

```shell
$ python ninjatracing out\gtx\.ninja_log >build.json
```

## Build GTx Browser

Build GTx Browser (the "chrome" target) with Ninja using the command:

```shell
$ autoninja -C out\gtx chrome
```

`autoninja` is a wrapper that automatically provides optimal values for the
arguments passed to `ninja`.

You can get a list of all of the other build targets from GN by running
`gn ls out/gtx` from the command line. To compile one, pass to Ninja
the GN label with no preceding "//" (so for `//chrome/test:unit_tests`
use ninja -C out/gtx chrome/test:unit_tests`).

## Run GTx Browser

Once it is built, you can simply run the browser:

```shell
$ out\gtx\gtxbrowser.exe
# OR for linux or mac
$ out/gtx/gtxbrowser
```

(The ".exe" suffix in the command is actually optional).
