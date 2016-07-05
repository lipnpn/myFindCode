echo -e "Begin combined build process.\n"
#    XCODEBUILD_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin
#    XCODEBUILD=$XCODEBUILD_PATH/xcodebuild
PROJECTNAME="Masonry"
xcodebuild -project "${PROJECTNAME}.xcodeproj" -target "${PROJECTNAME} iOS"  clean

echo -e "xcode build executable path: $XCODEBUILD\nBuiding i386 static library.\n"
xcodebuild -project "${PROJECTNAME}.xcodeproj" -target "${PROJECTNAME} iOS" -sdk "iphonesimulator" "ARCHS=i386 x86_64" "VALID_ARCHS=i386 x86_64" -configuration "Release" build
echo -e "Buiding ARM static library.\n"
xcodebuild -project "${PROJECTNAME}.xcodeproj" -target  "${PROJECTNAME} iOS" -sdk "iphoneos" "ARCHS=armv7 arm64" "VALID_ARCHS=armv7 arm64" -configuration "Release" build
echo -e "Combine ARM and i386 libs.\nOutput: Configuration/libUtilities.a\n"
[ -d build/Release-combined ] || mkdir build/Release-combined
mkdir Framework
cp -r "build/Release-iphoneos/${PROJECTNAME}.framework" "Framework/${PROJECTNAME}.framework"
lipo -create -output "Framework/${PROJECTNAME}.framework/${PROJECTNAME}" "build/Release-iphoneos/${PROJECTNAME}.framework/${PROJECTNAME}" "build/Release-iphonesimulator/${PROJECTNAME}.framework/${PROJECTNAME}"
rm -r build

echo -e "Done!\n"