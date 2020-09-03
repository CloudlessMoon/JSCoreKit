
Pod::Spec.new do |s|
  s.name         = "JSCoreKit"
  s.version      = "0.0.1"
  s.summary      = "JSCoreKit"
  s.homepage     = "https://github.com/jiasongs/JSCoreKit"
  s.author       = { "jiasong" => "593908937@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_versions = ["4.2", "5.0"]
  s.source       = { :git => "https://github.com/jiasongs/JSCoreKit.git", :tag => "#{s.version}" }
  s.frameworks   = "Foundation", "UIKit"
  s.source_files = "JSCoreKit", "JSCoreKit/*.{h,m}"
  s.license      = "MIT"
  s.requires_arc = true
end
