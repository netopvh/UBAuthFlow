#
# Be sure to run `pod lib lint UBAuthFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UBAuthFlow'
  s.version          = '0.2.4'
  s.summary          = 'A short description of UBAuthFlow.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git.usemobile.com.br/libs-iOS/use-blue/auth'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tulio de Oliveira Parreiras' => 'tulio@usemobile.xyz' }
  s.source           = { :git => 'http://git.usemobile.com.br/libs-iOS/use-blue/auth.git', :tag => s.version.to_s }
  
  s.swift_version    = '4.2'
  s.ios.deployment_target = '10.1'
  
  s.source_files = 'UBAuthFlow/Classes/**/*'
  s.static_framework = true
  s.frameworks = 'UIKit'
  s.dependency 'USE_Coordinator'
  s.dependency 'TPKeyboardAvoiding'
  
  s.resource_bundles = {
    'UBAuthFlow' => ['UBAuthFlow/Assets/*.png']
  }
end
