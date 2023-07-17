#!/bin/bash

# Install IB Gateway
ibg_url="https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-macos-arm.dmg"
ibg_path=~/Downloads/$(basename "$ibg_url")
curl -L -o "$ibg_path" "$ibg_url"

hdiutil attach "$ibg_path"
ibg_version=$(diskutil list | grep 'IB Gateway' | awk '{print $5}')
"/Volumes/IB Gateway $ibg_version/IB Gateway $ibg_version Installer.app/Contents/MacOS/JavaApplicationStub" -q -dir "$HOME/Applications/IB Gateway $ibg_version"

hdiutil detach "/Volumes/IB Gateway $ibg_version"
rm ~/Desktop/IB\ Gateway\ $ibg_version

# Install IBC
ibc_releases_url="https://api.github.com/repos/IbcAlpha/IBC/releases"
ibc_url=$(curl -s "$ibc_releases_url" | jq -r '.[] | .assets[] | select(.name | contains("Macos")) | .browser_download_url' | head -n 1)
ibc_path=~/Downloads/$(basename "$ibc_url")
curl -L -o "$ibc_path" "$ibc_url"

sudo unzip -q "$ibc_path" -d /opt/ibc
sudo chmod o+x /opt/ibc/*.sh /opt/ibc/*/*.sh
mkdir ~/ibc
cp '/opt/ibc/config.ini' ~/ibc/

# Configure IBC
gatewaystartmacos_path="/opt/ibc/gatewaystartmacos.sh"
existing_line=$(cat <<'EOF'
        do script \\"\$0 -inline\\"
EOF
)
replacement_line=$(cat <<'EOF'
        do script \\"\$0 -inline\\" in window 1\n        set miniaturized of window 1 to true
EOF
)

sudo sed -i '' "s/TWS_MAJOR_VRSN=.*/TWS_MAJOR_VRSN=$ibg_version/" "$gatewaystartmacos_path"
sudo sed -i '' "s/$existing_line/$replacement_line/" "$gatewaystartmacos_path"
./Configure\ IBC\ config_ini.sh

# launchd IBC
plist_contents=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.$USER.ibc</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>/opt/ibc/gatewaystartmacos.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
)

mkdir ~/Library/LaunchAgents/
echo "$plist_contents" >> ~/Library/LaunchAgents/com.user.$USER.ibc.plist
sudo chmod 600 ~/Library/LaunchAgents/com.user.$USER.ibc.plist
launchctl load ~/Library/LaunchAgents/com.user.$USER.ibc.plist
