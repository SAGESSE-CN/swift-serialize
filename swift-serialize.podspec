Pod::Spec.new do |s|
	s.name         = "swift-serialize"
	s.version      = "master-0.1"
	s.summary      = "swift object serialization/unserialization of json"
	s.homepage     = "https://github.com/sagesse-cn/swift-serialize"
	s.license      = "MIT"
	s.author       = { "sagesse-cn" => "gdmmyzc@163.com" }
	s.platform     = :ios, "7.0"
	s.source       = { :git => "https://github.com/sagesse-cn/swift-serialize.git", :tag => s.version.to_s }
	s.source_files  = "SFSerialize", "SFSerialize/*.swift"
	s.requires_arc = true
end
