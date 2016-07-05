echo -e "Begin combined build process.\n"
#    XCODEBUILD_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin
#    XCODEBUILD=$XCODEBUILD_PATH/xcodebuild
PROJECTNAME="Masonry"
INFOPLIST_FILE="${PROJECTNAME}/Info.plist"
echo "projectname----> ${PROJECTNAME}.xcodeproj"
xcodebuild -project "${PROJECTNAME}.xcodeproj" -target "${PROJECTNAME} iOS"  clean

