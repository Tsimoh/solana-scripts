#!/bin/bash
#init constant
key=$(solana address)
#time_const = slot time * 1000
time_const=459
#let's go
cluster_slot=`solana slot`
next_slots=`solana leader-schedule -v | grep $key | awk -v var=$cluster_slot '$1>=var' | sed -n '5~4 p'| cut -d ' ' -f3` 
current_slot=`solana leader-schedule -v | grep $key | awk -v var=$cluster_slot '$1>=var' | head -n1 | cut -d ' ' -f3`

left_slot=$((current_slot-cluster_slot))
let "secs = $left_slot * $time_const/1000"
echo $(($secs/86400))d $(($(($secs - $secs/86400*86400))/3600))h:$(($(($secs - $secs/86400*86400))%3600/60))m:$(($(($secs - $secs/86400*86400))%60))s

for var in $next_slots
do
left_slot=$((var-current_slot))
let "secs = $left_slot * $time_const/1000"
echo $(($secs/86400))d $(($(($secs - $secs/86400*86400))/3600))h:$(($(($secs - $secs/86400*86400))%3600/60))m:$(($(($secs - $secs/86400*86400))%60))s
current_slot=$var
done
