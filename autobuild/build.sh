#!/bin/bash

function failed()
{
  echo "Failed $*: $@" >&2
  exit 1
}

export OUTPUT=$WORKSPACE/output
rm -rf $OUTPUT
mkdir -p $OUTPUT

PROFILE_HOME=~/Library/MobileDevice/Provisioning\ Profiles/
[ -d "$PROFILE_HOME" ] || mkdir -p "$PROFILE_HOME"

KEYCHAIN=~/Library/Keychains/login.keychain
security unlock -p `cat ~/.build_password`

MARKETING_VERSION=`agvtool what-marketing-version -terse1`;
cp $WORKSPACE/MBlock/MBlock-Info.plist $WORKSPACE/MBlock/MBlock-Info.plist.orig
COMMIT_MSG=`git log -5 --format=format:"%s"`

for CONFIG in $CONFIGS; do

  if [ "$CONFIG" == "AdHoc" ]
  then
    VERSION="$MARKETING_VERSION.build$BUILD_NUMBER"
    agvtool new-version -all $VERSION
  else
    VERSION="$MARKETING_VERSION"
    cp $WORKSPACE/MBlock/MBlock-Info.plist.orig $WORKSPACE/MBlock/MBlock-Info.plist
  fi

  xcodebuild -target MBlock -configuration $CONFIG build || failed build;

  PROVISION="$WORKSPACE/autobuild/MBlock_$CONFIG.mobileprovision"

  APP_OUT="$OUTPUT/MBlock_$CONFIG.ipa"
  SYM_OUT="$OUTPUT/MBlock_$CONFIG.dSYM"
#  PROVISION_OUT="$OUTPUT/MBlock_$CONFIG.mobileprovision"

(
  cd build/$CONFIG-iphoneos || failed "no build output";
  rm -rf Payload
  rm -f *.ipa
  mkdir Payload
  cp -Rp *.app Payload/

#  if [ "$CONFIG" == "AdHoc" ]
#  then
#    cp -f $WORKSPACE/MBlock/Icon_512x512.png Payload/iTunesArtwork
#  fi

  zip -r $APP_OUT Payload
  zip -r $SYM_OUT *.dSYM

  curl http://testflightapp.com/api/builds.json \
    -F file=@$APP_OUT \
    -F dsym=@$SYM_OUT \
    -F api_token="$TF_API_TOKEN" \
    -F team_token="$TF_TEAM_TOKEN" \
    -F notes="$COMMIT_MSG" \
    -F notify=True \
    -F distribution_lists="$TF_LISTS"

)

done
