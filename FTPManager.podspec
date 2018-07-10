Pod::Spec.new do |s|
  s.name     = 'FTPManager'
  s.version  = '1.6.6'
  s.license  = 'MIT'
  s.summary  = 'An Objective-C class for simple, synchronous ftp access.'
  s.homepage = 'https://github.com/yellowei/FTPManager'
  s.author   = { "yellowei" => "hw0521@vip.qq.com" }

  s.source   = { :git => 'https://github.com/yellowei/FTPManager.git', :tag => "#{s.version}" }

  s.source_files = 'FTPManager/FTPManager.{h,m}'
  s.requires_arc = true

  s.ios.frameworks = 'CFNetwork'
  s.osx.frameworks = 'CoreServices'
end
