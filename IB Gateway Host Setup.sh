#!/bin/bash

# IB Gateway
cd ~/Downloads
curl -O https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-macos-arm.dmg && \
hdiutil attach ./ibgateway-stable-standalone-macos-arm.dmg && \
sudo /Volumes/IB\ Gateway\ 10.19/IB\ Gateway\ 10.19\ Installer.app/Contents/MacOS/JavaApplicationStub -q -dir ~/Applications/IB Gateway 10.19 && \
hdiutil detach /Volumes/IB\ Gateway\ 10.19