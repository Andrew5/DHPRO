Pod::Spec.new do |s|
  s.name         = "YUChineseSorting"
  s.version      = "1.0.2"
  s.summary      = "iOS通讯录联系人列表较完整(中文排序)"
  s.homepage     = "https://github.com/c6357/YUChineseSorting"
  s.license      = "MIT"
  s.author             = { "BruceYu" => "c6357@outlook.com" }
  s.platform     = :ios, "6.0"
  s.source       = {:git => 'https://github.com/c6357/YUChineseSorting.git', :tag => s.version}
  s.source_files = 'YUChineseSorting/ChineseSorting/**/*.{h,c,m}'
  s.requires_arc = true
end
