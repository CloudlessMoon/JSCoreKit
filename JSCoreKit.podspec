Pod::Spec.new do |s|
  s.name             = "JSCoreKit"
  
  s.version          = "2.0.0"
  s.platform         = :ios, "15.0"
  s.swift_versions   = ["5.9"]
  s.requires_arc     = true

  s.summary          = "JSCoreKit"
  s.homepage         = "https://github.com/CloudlessMoon/JSCoreKit"
  s.license          = "MIT"
  s.author           = { "jiasong" => "593908937@qq.com" }
  s.source           = { :git => "https://github.com/CloudlessMoon/JSCoreKit.git", :tag => "#{s.version}" }
  
  s.source_files = "Sources/**/*.{h,m,swift}"
end
