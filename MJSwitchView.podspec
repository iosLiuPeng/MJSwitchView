Pod::Spec.new do |s|
  s.name             = 'MJSwitchView'
  s.version          = '1.0.0'
  s.summary          = 'The Switch View visible in xib/SB.'
  s.homepage         = 'https://github.com/iosLiuPeng/MJSwitchView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iosLiuPeng' => '392009255@qq.com' }
  s.source           = { :git => 'https://github.com/iosLiuPeng/MJSwitchView.git', :tag => s.version.to_s }
  s.platform     = :ios 
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/*'
  s.frameworks = 'UIKit'
  # s.resource_bundles = {
  #   'view' => ['Assets/*.png']
  # }
end
