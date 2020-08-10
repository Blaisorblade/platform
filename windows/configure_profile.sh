#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# GNU Lesser General Public License Version 2.1 or later
# See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

# Based on <coq>/dev/build/windows/configure_profile.sh

# (C) 2016 Intel Deutschland GmbH
# Author: Michael Soegtrop
#
# Released to the public by Intel under the
# GNU Lesser General Public License Version 2.1 or later
# See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

###################### CONFIGURE CYGWIN USER PROFILE FOR BUILDING COQ ######################

rcfile=~/.bash_profile
donefile=~/.bash_profile.upated

if [ ! -f $donefile ] ; then
  # to learn about `exec >> $file`, see https://www.tldp.org/LDP/abs/html/x17974.html
  exec 6>&1            # save stdout in file descripot 6
  exec >> $rcfile      # append stdout to $rcfile

  if [ "$1" != "" ] && [ "$1" != " " ]; then
    echo export http_proxy="http://$1"
    echo export https_proxy="http://$1"
    echo export ftp_proxy="http://$1"
  fi

  mkdir -p "$RESULT_INSTALLDIR_CFMT/bin"

  # A tightly controlled path helps to avoid issues
  # Note: the order is important: first have the cygwin binaries, then the mingw binaries in the path!
  # Note: /bin is mounted at /usr/bin and /lib at /usr/lib and it is common to use /usr/bin in PATH
  # See cat /proc/mounts
  echo "export PATH=/build/bin_special:/usr/local/bin:/usr/bin:/usr/$TARGET_ARCH/sys-root/mingw/bin:/cygdrive/c/Windows/system32:/cygdrive/c/Windows"

  # find and xargs complain if the environment is larger than (I think) 8k.
  # ORIGINAL_PATH (set by cygwin) can be a few k and exceed the limit
  echo unset ORIGINAL_PATH
  # Other installations of OCaml will mess up things
  echo unset OCAMLLIB

  exec 1>&6 6>&-       # Restore stdout from file descriptor 6 and close file descriptor #6

  touch $donefile
fi

###################### REPORT USER FOLDER ######################

echo $HOME > /var/tmp/main_user_folder.txt
