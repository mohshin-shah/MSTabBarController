
Pod::Spec.new do |s|
s.name             = 'MSTabBarController'
s.version          = '0.0.4'
s.summary          = 'Animating UITabBarController selection and enabling gesture based tab selection.'

s.description      = 'UITabBarController animation using pan gesture.It also works using the tab selection.'

s.homepage         = 'https://github.com/mohshin-shah/MSTabBarController'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Mohshin Shah' => 'mohshinshah@gmail.com' }
s.source           = { :git => 'https://github.com/mohshin-shah/MSTabBarController.git', :tag => s.version.to_s }
s.social_media_url = 'https://facebook.com/mohshin.19'

s.ios.deployment_target = '8.0'

s.source_files = 'MSTabBarController/**/*'

# s.resource_bundles = {
#   'MSTabBarController' => ['MSTabBarController/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit'
end
