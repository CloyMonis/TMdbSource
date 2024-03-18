#
# Be sure to run `pod lib lint TMdbSource.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMdbSource'
  s.version          = '0.0.5'
  s.summary          = 'TMdbSource acts as a network client for https://www.themoviedb.org/'
  s.description      = "TMdbSource can be used to access the latest and popular movies using this library"
  s.homepage         = 'https://github.com/Cloy.Monis/TMdbSource'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CloyMonis' => 'cloymonis1991@gmail.com' }
  s.source           = { :git => 'https://github.com/CloyMonis/TMdbSource.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.source_files = 'TMdbSource/Classes/**/*'
  s.vendored_frameworks = 'TMdbSource.xcframework'
  
end
