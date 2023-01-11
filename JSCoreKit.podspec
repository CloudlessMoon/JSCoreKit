
Pod::Spec.new do |s|
  s.name                 = "JSCoreKit"
  s.version              = "0.2.8"
  s.summary              = "JSCoreKit"
  s.homepage             = "https://github.com/jiasongs/JSCoreKit"
  s.author               = { "jiasong" => "593908937@qq.com" }
  s.platform             = :ios, "11.0"
  s.swift_versions       = ["4.2", "5.0"]
  s.source               = { :git => "https://github.com/jiasongs/JSCoreKit.git", :tag => "#{s.version}" }
  s.frameworks           = "Foundation", "UIKit", "CoreGraphics", "QuartzCore"
  s.license              = "MIT"
  s.requires_arc         = true
  s.pod_target_xcconfig  = { "APPLICATION_EXTENSION_API_ONLY" => "NO" }
  s.source_files         = "Sources"

  s.subspec "Core" do |ss|
    ss.source_files = "Sources/**/**/*.{h,m,swift}"
  end
end
