#!/bin/sh

# This is the Dockerbase install script, for release candidates of the
# Dockerbase 0.9.0!
#
# Are you looking at this in your web browser, and would like to install Dockerbase?
# Just open up your terminal and type:
#
#    curl https://github.com/dockerbase/dockerbase/install.sh | sh
#
# Dockerbase currently supports:
#   - Mac: OS X 10.6 and above
#   - Linux: x86 and x86_64 systems


RELEASE="0.9.0"


# Now, on to the actual installer!

## NOTE sh NOT bash. This script should be POSIX sh only, since we don't
## know what shell the user has. Debian uses 'dash' for 'sh', for
## example.

PREFIX="/usr/local"

set -e
set -u

# Let's display everything on stderr.
exec 1>&2

UNAME=$(uname)
if [ "$UNAME" != "Linux" -a "$UNAME" != "Darwin" ] ; then
    echo "Sorry, this OS is not supported yet."
    exit 1
fi


if [ "$UNAME" = "Darwin" ] ; then
  ### OSX ###
  if [ "i386" != "$(uname -p)" -o "1" != "$(sysctl -n hw.cpu64bit_capable 2>/dev/null || echo 0)" ] ; then
    # Can't just test uname -m = x86_64, because Snow Leopard can
    # return other values.
    echo "Only 64-bit Intel processors are supported at this time."
    exit 1
  fi
  PLATFORM="os.osx.x86_64"
elif [ "$UNAME" = "Linux" ] ; then
  ### Linux ###
  LINUX_ARCH=$(uname -m)
  if [ "${LINUX_ARCH}" = "i686" ] ; then
    PLATFORM="os.linux.x86_32"
  elif [ "${LINUX_ARCH}" = "x86_64" ] ; then
    PLATFORM="os.linux.x86_64"
  else
    echo "Unusable architecture: ${LINUX_ARCH}"
    echo "Dockerbase only supports i686 and x86_64 for now."
    exit 1
  fi
fi

trap "echo Installation failed." EXIT

# If you already have a tropohouse/warehouse, we do a clean install here:
if [ -e "$HOME/.dockerbase" ]; then
  echo "Removing your existing Dockerbase installation."
  rm -rf "$HOME/.dockerbase"
fi

TARBALL_URL="http://github.com/dockerbase/dockerbase/zipball/master/"

INSTALL_TMPDIR="$HOME/.dockerbase-install-tmp"
rm -rf "$INSTALL_TMPDIR"
mkdir "$INSTALL_TMPDIR"
cd "$INSTALL_TMPDIR"
echo "Downloading Dockerbase distribution"
curl --progress-bar --fail "$TARBALL_URL" -L -o dockerbase-master.zip
unzip dockerbase-master.zip
mv dockerbase-dockerbase-* "$HOME/.dockerbase"
# just double-checking :)
test -x "$HOME/.dockerbase/dockerbase"
cd -
# clean up the install temprorary folder
rm -rf "$INSTALL_TMPDIR"


echo
echo "Dockerbase ${RELEASE} has been installed in your home directory (~/.dockerbase)."

LAUNCHER="$HOME/.dockerbase/dockerbase"




if cp "$LAUNCHER" "$PREFIX/bin/dockerbase" >/dev/null 2>&1; then
  echo "Writing a launcher script to $PREFIX/bin/dockerbase for your convenience."
  cat <<"EOF"

To get started fast:

  $ sudo dockerbase bootstrap jenkins
  $ sudo dockerbase start jenkins
  $ sudo dockerbase stop jenkins

Or see the docs at:

  github.com/dockerbase/dockerbase

EOF
elif type sudo >/dev/null 2>&1; then
  echo "Writing a launcher script to $PREFIX/bin/dockerbase for your convenience."
  echo "This may prompt for your password."

  # New macs (10.9+) don't ship with /usr/local, however it is still in
  # the default PATH. We still install there, we just need to create the
  # directory first.
  # XXX this means that we can run sudo too many times. we should never
  #     run it more than once if it fails the first time
  if [ ! -d "$PREFIX/bin" ] ; then
      sudo mkdir -m 755 "$PREFIX" || true
      sudo mkdir -m 755 "$PREFIX/bin" || true
  fi

  if sudo cp "$LAUNCHER" "$PREFIX/bin/dockerbase"; then
    cat <<"EOF"

To get started fast:

  $ sudo dockerbase bootstrap jenkins
  $ sudo dockerbase start jenkins
  $ sudo dockerbase stop jenkins

Or see the docs at:

  github.com/dockerbase/dockerbase

EOF
  else
    cat <<EOF

Couldn't write the launcher script. Please either:

  (1) Run the following as root:
        cp "$LAUNCHER" /usr/local/bin/dockerbase
  (2) Add "\$HOME/.dockerbase" to your path, or
  (3) Rerun this command to try again.

Then to get started, take a look at 'dockerbase --help' or see the docs at
github.com/dockerbase/dockerbase.
EOF
  fi
else
  cat <<EOF

Now you need to do one of the following:

  (1) Add "\$HOME/.dockerbase" to your path, or
  (2) Run this command as root:
        cp "$LAUNCHER" /usr/local/bin/dockerbase

Then to get started, take a look at 'dockerbase --help' or see the docs at
github.com/dockerbase/dockerbase.
EOF
fi


trap - EXIT

