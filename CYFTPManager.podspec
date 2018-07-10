Pod::Spec.new do |s|
  s.name     = 'CYFTPManager'
  s.version  = '1.6.7'
  s.license  = 'MIT'
  s.summary  = 'An Objective-C class for simple, synchronous ftp access.'
  s.homepage = 'https://github.com/yellowei/CYFTPManager'
  s.author   = { "yellowei" => "hw0521@vip.qq.com" }
  s.platform     = :ios, "8.0"
  s.source   = { :git => 'https://github.com/yellowei/CYFTPManager.git', :tag => "#{s.version}" }

  s.source_files = 'CYFTPManager/FTPManager.{h,m}'
  s.requires_arc = true

  s.ios.frameworks = 'CFNetwork'
  s.osx.frameworks = 'CoreServices'
end
