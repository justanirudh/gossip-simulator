#!/bin/bash
COUNTER=4096
while [  $COUNTER -lt 4097 ]; do
	./project2 $COUNTER fu gossip
	let COUNTER=COUNTER*2 
done
