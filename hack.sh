#!/usr/bin/env bash

CSS=$(<slack-dark.css)
JS=$(<slack-dark.js)

SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
SLACK_FILE_PATH="${SLACK_RESOURCES_DIR}/app.asar.unpacked/dist/ssb-interop.bundle.js"

TEMP="***whatever***"
HACK="${JS/CSS_PLACEHOLDER/$CSS}"

echo "Hacking Slack..."

sudo npx asar extract ${SLACK_RESOURCES_DIR}/app.asar ${SLACK_RESOURCES_DIR}/app.asar.unpacked
sudo sed -i '' '/\/\/START_SLACK_DARK_MOD/,/\/\/END_SLACK_DARK_MOD/d' ${SLACK_FILE_PATH}
sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$HACK"
sudo npx asar pack ${SLACK_RESOURCES_DIR}/app.asar.unpacked ${SLACK_RESOURCES_DIR}/app.asar
echo "Done"
osascript -e 'quit app "slack"'
echo "Restarting Slack"
export SLACK_DEVELOPER_MENU=true
open -a /Applications/Slack.app
echo "Your eyes are saved!"



