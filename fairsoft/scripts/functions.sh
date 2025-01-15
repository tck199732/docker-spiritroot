#!/bin/bash
# define functions needed later on

#_____________________________________________________________________
# checks if one of the files is existing and print message
# updated to check a list of packages because some libraries
# have slightly different names on differnt platforms
function not_there {
    pack=$1
    shift
    files=$*
    retval=0
    for file in $files;do
      if [ -e $file ];
      then
        echo "*** Package $pack is OK ***"
        return 1
      fi
    done

    echo "*** Compiling $pack ................ "
    return 0
}

#_____________________________________________________________________
# check if package is already unpacked and do the unpacking if
# necessary
function untar {
    pack=$1
    tarf=$2
    if [ -d $pack ]; then
        echo "*** Package $pack already unpacked ***"
    else
        echo "*** Unpacking $tarf .............."
        if [ "$(file $tarf | grep -c gzip)" = "1" ]; then
            tar zxf $tarf
        elif [ "$(file $tarf | grep -c bzip2)" = "1" ]; then
            tar xjf $tarf
        elif [ "$(file $tarf | grep -c Zip)" = "1" ]; then
            unzip $tarf
        else
            echo "--E-- Cannot unpack package $pack"
            exit
        fi
    fi
}

#_____________________________________________________________________
# check if file exists after the compilation process
# return error code
function check_success {
    pack=$1
    file=$2
    if [ -e $file ];
    then
      echo "*** $1 compiled successfully ***"
      return 1
    else
      echo "*** ERROR: $1 could not be created."
      return 0
    fi
}

#_____________________________________________________________________
# function to do the patching. This should avoid problems with applying
# the same patch again. In each package directory a apllied_patches.txt
# file is created and the information about the aplied patches is
# saved. When runing the script again it is checked if the patch
# was already aplied. If this is the case no action is taken, else
# the patch is applied
function mypatch {
  patch_full_file=$1
  patch_file=$(basename "$patch_full_file")
  if [ ! -e applied_patches.txt ]; then
    patch -p0 < $patch_full_file
    echo $patch_file >> applied_patches.txt
  else
    if [ "$(grep -c $patch_file applied_patches.txt )" = "1" ]; then
      echo "The patch $patch_file is already applied."
    else
      patch -p0 < $patch_full_file
      echo $patch_file >> applied_patches.txt
    fi
  fi
}

#_____________________________________________________________________
# function perform sed command differently on linux and on Mac Os X
# return error code
# first parameter is the text to search for, the second is the
# replacement and the third one defines the filename
# with the fourth on defines if the the string
# contains a /
function mysed {

    # Assert that we got enough arguments
    if [ $# -lt 3 ];
    then
      echo "mysed: 3 or 4 arguments needed"
      echo "Script was called only with $# arguments"
      echo "Searchstring: $1"
      echo "Replacement : $2"
      echo "Filename    : $3"
      if [ $# -eq 4 ];
      then
        echo "Option    : $4"
      fi
      return 1
    fi

    old=$1
    new=$2
    change_file=$3
    if [ $# -eq 4 ];
    then
      has_slash=yes
    fi


   if [ "$platform" = "linux" ];
    then
      if [ "$has_slash" = "yes" ];
      then
        sed -e "s#$old#$new#g" -i'' $change_file
      else
        sed -e "s/$old/$new/g" -i'' $change_file
      fi
    elif [ "$platform" = "macosx" ];
    then
      if [ "$has_slash" = "yes" ];
      then
        sed -e "s#$old#$new#g" -i '' $change_file
      else
        sed -e "s/$old/$new/g" -i '' $change_file
      fi
    elif [ "$platform" = "solaris" ];
    then
      mv $change_file tmpfile
      if [ "$has_slash" = "yes" ];
      then
        sed -e "s#$old#$new#g" tmpfile > $change_file
      else
        sed -e "s/$old/$new/g" tmpfile > $change_file
      fi
      rm tmpfile
    fi
}


#_____________________________________________________________________
function is_in_path {
    # This function checks if a file exists in the $PATH.
    # To do so it uses which.
    # There are several versions of which available with different
    # return values. Either it is "" or "no searched program in PATH" or
    # "/usr/bin/which: no <searched file>".
    # To check for all differnt versions check if the return statement is
    # not "".
    # If it is not "" check if the return value starts with no or have
    # the string "no <searched file> in the return string. If so set
    # return value to "". So all negative return statements go to "".
    # If program is found in Path return 1, else return 0.

    searched_program=$1
    answer=$(which $searched_program)
    if [ "$answer" != "" ];
    then
      no_program=$(which $searched_program | grep -c '^no' )
      no_program1=$(which $searched_program | grep -c "^no $searched_program")
      if [ "$no_program" != "0" -o "$no_program1" != "0" ];
      then
        answer=""
      fi
    fi

    if [ "$answer" != "" ];
    then
      return 1
    else
      return 0
    fi
}

#_____________________________________________________________________
function create_links {

     # create symbolic links from files with suffix $2 to $1

      ext1=$1
      ext2=$2

      for file in $(ls *.$ext1);
      do
         if [ ! -L ${file%.*}.$ext2 ]; then
           ln -s $file ${file%.*}.$ext2
         fi
      done
}

#_____________________________________________________________________
function download_file {
      # download the file from the given location using either wget or
      # curl depending which one is available

      url=$1

      if [ "$install_curl" = "yes" ]; # no curl but wget
      then
        wget $url
      else
        # -L follow redirections which is needed for boost
        curl -O -L $url
      fi
}

function create_installation_directories {
    # This function creates the defined installation directory
    # and all directories/links inside

    mkdir -p $SIMPATH_INSTALL/bin
    mkdir -p $SIMPATH_INSTALL/include
    mkdir -p $SIMPATH_INSTALL/lib
    mkdir -p $SIMPATH_INSTALL/share
    if [ ! -e $SIMPATH_INSTALL/lib64 ]; then
      ln -s $SIMPATH_INSTALL/lib $SIMPATH_INSTALL/lib64
    fi
}
