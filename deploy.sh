#!/bin/bash

cp -r /home/norm/EtherAds/src/* /home/norm/EtherAds/docs
cp -r /home/norm/EtherAds/build/contracts/* /home/norm/EtherAds/docs/contracts
cp /home/norm/EtherAds/build/contracts/EtherAds.json /home/norm/EtherAds/docs
git add .
git commit -m "update"
git push origin master

