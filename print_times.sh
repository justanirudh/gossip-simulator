#!/bin/bash
COUNTER=4096
while [  $COUNTER -lt 34970 ]; do
	./project2 $COUNTER line gossip
	let COUNTER=COUNTER*2 
done
