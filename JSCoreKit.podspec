
Pod::Spec.new do |s|
  s.name         = "JSCoreKit"
  s.version      = "0.1.9"
  s.summary      = "JSCoreKit"
  s.homepage     = "https://github.com/jiasongs/JSCoreKit"
  s.author       = { "jiasong" => "593908937@qq.com" }
  s.platform     = :ios, "10.0"
  s.swift_versions = ["4.2", "5.0"]
  s.source       = { :git => "https://github.com/jiasongs/JSCoreKit.git", :tag => "#{s.version}" }
  s.frameworks   = "Foundation", "UIKit", "CoreGraphics", "QuartzCore"
  s.source_files = "Sources"
  s.license      = "MIT"
  s.requires_arc = true

  s.subspec "Core" do |ss|
    ss.source_files = "Sources/**/*.{h,m}", "Sources/**/**/*.{h,m}"
  end
end
