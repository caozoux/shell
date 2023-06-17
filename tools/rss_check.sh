#!/bin/bash

cnt=0
listdata=(
"Rss"
"Pss"
"Shared_Clean"
"Shared_Dirty"
"Private_Clean"
"Private_Dirty"
"Referenced"
"Anonymous"
"LazyFree"
"AnonHugePages"
"ShmemPmdMapped"
"Shared_Hugetlb"
"Private_Hugetlb"
)


cat /proc/$1/smaps  > ~/log
for item in ${listdata[@]}
do
  cnt=0
  cat ~/log | grep $item | grep -v " 0 k" | awk '{print $2}' > /tmp/smaplog
  while read line
  do
     cnt=`expr $cnt + $line`
  done < /tmp/smaplog
  echo $item $cnt
done

#cat /proc/$1/smaps | grep Rss | grep -v " 0 k" | awk '{print $2}' > /tmp/smaplog
#cat /proc/$1/smaps | grep AnonHugePages | grep -v " 0 k" | awk '{print $2}' > /tmp/smaplog
#cat /proc/$1/smaps | grep Anonymous | grep -v " 0 k" | awk '{print $2}' > /tmp/smaplog
exit 0
cat /proc/$1/smaps | grep Private_Dirty | grep -v " 0 k" | awk '{print $2}' > /tmp/smaplog
while read line
do
   cnt=`expr $cnt + $line`
done < /tmp/smaplog
echo $cnt
