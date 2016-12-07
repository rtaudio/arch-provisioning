#!/bin/sh

export root_dir="${PWD}"
export work_dir="${PWD}/work"

mkdir -p "$work_dir/root" "$work_dir/root_from_targz" "$work_dir/download" "$work_dir/root_chroot_tmp" 



python_exec() {
  echo "print($1)" | python
}


install_package() {
	apt-get install $1
}

require_root() {
	if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 1>&2
	   exit 1
	fi	
}


require_rootfs_initialized() {
	if [ ! -d "$work_dir/root/var" ]; then
		echo "$work_dir/root is not initialized yet!"
		exit 1
	fi   
}

boardmanager_current() {
  cat "$work_dir/current_board" 2> /dev/null || echo ""
}

boardmanager_choose() {
	while [[ -z "`boardmanager_current`" ]]; do
		>&2 echo "choose a board:"
		>&2 ls boards
		read BOARD
		if [[ -f "boards/$BOARD" ]]; then
			mkdir -p root
			echo $BOARD > "$work_dir/current_board"
		fi
	done;

	export BOARD=`boardmanager_current`
	. ./boards/$BOARD
	>&2 echo
	>&2 echo "Selected Board: $BOARD" 
	>&2 echo

	echo $BOARD
}

boardmanager_hostname_ask() {
	echo "Enter hostname: [`cat root/etc/hostname`]:"
	read hn || hn=""
	if [[ ! -z "$hn" ]]; then
		echo "$hn" > root/etc/hostname
		echo "Hostname set to $hn"
	fi
}


prepfs_findfiles () {
  workdir=${PWD}

  ROOT_PATH="$1"
  LIST_FILE="$2"
  
  
  
  echo "Creating file list $LIST_FILE of $ROOT_PATH (workdir: $workdir)"
  
  rm -f "${LIST_FILE}"

  cd $ROOT_PATH

  find ./bin ./etc ./sbin ./var ./lib ./root ./home ./usr >$LIST_FILE

  if [[ -f ./init ]]; then
	 echo ./init >>$LIST_FILE
  fi



  for dir in ./boot ./dev ./home ./proc ./sys ./tmp ./mnt ./mnt/* ./run
  do
    if [[ -d $dir ]]; then
      echo $dir >>$LIST_FILE
    fi
  done 
  
  cd "$workdir"
  
  wc -l $LIST_FILE
}

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}
