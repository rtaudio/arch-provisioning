#!/bin/sh

. "$(dirname $0)/functions.sh"

LIST_FILE="$(dirname $0)/tmp/list"
prepfs_findfiles ./ $LIST_FILE


EXCLUDES=$(prepfs_excludes)
echo ""
echo "Exlucde list:"
echo $EXCLUDES
echo ""
echo ""


rm -f ${LIST_FILE}_del

echo "Filtering..."

strt="`cat $LIST_FILE`"

for exp in $EXCLUDES; do
	echo "Filtering $exp"
	echo "$strt" | grep $exp >> ${LIST_FILE}_del
done


echo "Filtering done."

nlines=`wc -l ${LIST_FILE}_del | cut -d ' ' -f 1`
echo "Files to be deleted: $nlines"



read -p "This will cleanup the rootfs in current directory, leaving a working but not maintainable rootfs, sure (y/n)?" yn

case "$yn" in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no."; exit;;
esac

read -p "Press ENTER to start it (final confirmation)" yn


xargs rm -f -r < ${LIST_FILE}_del

rm -f -r opt

