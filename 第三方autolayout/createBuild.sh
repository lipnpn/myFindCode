echo -e "Begin combined build process.\n"
#    XCODEBUILD_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin
#    XCODEBUILD=$XCODEBUILD_PATH/xcodebuild

rm -r Framework
xcodebuild -project Masonry.xcodeproj -target "Masonry iOS"  clean

echo -e "xcode build executable path: $XCODEBUILD\nBuiding i386 static library.\n"
xcodebuild -project Masonry.xcodeproj -target "Masonry iOS" -sdk "iphonesimulator" "ARCHS=i386 x86_64" "VALID_ARCHS=i386 x86_64" -configuration "Release" build
echo -e "Buiding ARM static library.\n"
xcodebuild -project Masonry.xcodeproj -target "Masonry iOS" -sdk "iphoneos" "ARCHS=armv7 arm64" "VALID_ARCHS=armv7 arm64" -configuration "Release" build
echo -e "Combine ARM and i386 libs.\nOutput: Configuration/libUtilities.a\n"
[ -d build/Release-combined ] || mkdir build/Release-combined
mkdir Framework
cp -r "build/Release-iphoneos/Masonry.framework" "Framework/Masonry.framework"
lipo -create -output "Framework/Masonry.framework/Masonry" "build/Release-iphoneos/Masonry.framework/Masonry" "build/Release-iphonesimulator/Masonry.framework/Masonry"
rm -r build

echo -e "Done!\n"