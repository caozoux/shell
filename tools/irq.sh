#!/bin/bash

#start_irq=410
start_irq=144
cat_irq=$start_irq
for i in `seq 0 127`
do
  cat /proc/irq/$cat_irq/smp_affinity
  cat_irq=`expr $cat_irq + 1`
done

exit 0
for i in `seq 0 127`
do
  bits0=('0' '0' '0' '0' '0' '0' '0' '0')
  bits1=('0' '0' '0' '0' '0' '0' '0' '0')
  bits2=('0' '0' '0' '0' '0' '0' '0' '0')
  bits3=('0' '0' '0' '0' '0' '0' '0' '0')
  #bitsarray=`echo ${bits0[*]}+ ${bits1[*]}`
  l=`expr $i / 32`
  m=`expr $i % 32`

  j=`expr $m % 4`
  k=`expr $m / 4`
  if [ $l -eq 0 ]
  then
    bits0[$k]=$((1<<$j))
  elif [ $l -eq 1 ]
  then
    bits1[$k]=$((1<<$j))
  elif [ $l -eq 2 ]
  then
    bits2[$k]=$((1<<$j))
  elif [ $l -eq 3 ]
  then
    bits3[$k]=$((1<<$j))
  fi
  #bits0[$k]=$j
  bitsarray=`echo ${bits0[@]},${bits1[@]},${bits2[@]},${bits3[@]} | sed 's/ //g'`
  echo $start_irq $l $k $j $bitsarray
  echo $bitsarray > /proc/irq/$start_irq/smp_affinity
  start_irq=`expr $start_irq + 1`
done
