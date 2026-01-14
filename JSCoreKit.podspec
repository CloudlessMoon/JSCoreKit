
Pod::Spec.new do |s|
  s.name                 = "JSCoreKit"
  s.version              = "1.0.8"
  s.summary              = "JSCoreKit"
  s.homepage             = "https://github.com/CloudlessMoon/JSCoreKit"
  s.author               = { "jiasong" => "593908937@qq.com" }
  s.platform             = :ios, "13.0"
  s.swift_versions       = ["5.1"]
  s.source               = { :git => "https://github.com/CloudlessMoon/JSCoreKit.git", :tag => "#{s.version}" }
  s.frameworks           = "Foundation", "UIKit", "CoreGraphics", "QuartzCore"
  s.license              = "MIT"
  s.requires_arc         = true
  s.pod_target_xcconfig  = { "APPLICATION_EXTENSION_API_ONLY" => "NO" }
  s.source_files         = "Sources"

  s.source_files = "Sources/**/*.{h,m,swift}"
end
