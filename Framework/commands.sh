rm -rf TMdbSource-iphonesimulator.xcarchive
rm -rf TMdbSource-iphoneos.xcarchive
rm -rf TMdbSource.xcframework

xcodebuild archive \
 -project TMdbSource/TMdbSource.xcodeproj \
 -scheme TMdbSource \
  ONLY_ACTIVE_ARCH=YES \
 -archivePath TMdbSource-iphonesimulator.xcarchive \
 -sdk iphonesimulator \
 SKIP_INSTALL=NO


xcodebuild archive \
 -project TMdbSource/TMdbSource.xcodeproj \
 -scheme TMdbSource \
  ONLY_ACTIVE_ARCH=YES -arch arm64 \
 -archivePath TMdbSource-iphoneos.xcarchive \
 -sdk iphoneos \
 SKIP_INSTALL=NO
 
xcodebuild -create-xcframework \
  -framework ./TMdbSource-iphonesimulator.xcarchive/Products/Library/Frameworks/TMdbSource.framework \
  -framework ./TMdbSource-iphoneos.xcarchive/Products/Library/Frameworks/TMdbSource.framework \
  -output TMdbSource.xcframework
