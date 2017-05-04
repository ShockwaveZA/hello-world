LOGFILE="changes.log"
DIR="orig"
RDIR="sync"
#RSERVER="remoteserver"
#RUSER="remoteuser"
#cd "$RDIR"

for i in $(find $DIR -type f)
do

# Get file name
FILE=`echo $i|awk 'BEGIN {FS="/"} {print $6}'`
REMOTEFIND=`"find $RDIR -type f -name $FILE"`
# When getting file name from remote server then the command is
# REMOTEFIND=`ssh $RUSER@$RSERVER "find $RDIR -type f -name $FILE"`
if [ ! -n "$REMOTEFIND" ]
then
echo -e "copied file $i " >> "$LOGFILE"
openssl enc -nosalt -aes-128-cbc -in "$i" -out "$i.aes" -p
cp "$i.aes" $RDIR
# When copying to remote server then the command is
# scp "$i.aes" $RUSER@$RSERVER:$RDIR
rm "$i.aes"
fi
done

echo -e "Remote backup `date` SUCCESS\n-----------------------------" >> "$LOGFILE"
