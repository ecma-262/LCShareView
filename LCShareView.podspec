Pod::Spec.new do |s|
  s.name             = "LCShareView"
  s.version          = "1.0.0"
  s.summary          = "Custom UIPageControl"
  s.homepage         = "https://github.com/bawn/LCAnimatedPageControl"
  s.license          = 'MIT'
  s.author           = { "bawn" => "lc5491137@gmail.com" }
  s.source           = { :git => "https://github.com/bawn/LCShareView.git", :tag => "1.0.0" }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.frameworks       = 'Foundation', 'UIKit'
  s.source_files     = 'LCShareView/LCShareView.{h,m}'
  s.dependency       "UIImage+BlurredFrame", "~> 0.0.4"

end
