Pod::Spec.new do |s|
  s.name     = 'CYFTPManager'
  s.version  = '1.6.8'
  s.license  = 'MIT'
  s.summary  = 'An Objective-C class for simple, synchronous ftp access.'
  s.homepage = 'https://github.com/yellowei/CYFTPManager'
  s.author   = { "yellowei" => "hw0521@vip.qq.com" }
  s.platform     = :ios, "8.0"
  s.source   = { :git => 'https://github.com/yellowei/CYFTPManager.git', :tag => "#{s.version}" }
  s.requires_arc = true

  s.ios.frameworks = 'CFNetwork'
  s.osx.frameworks = 'CoreServices'

  s.subspec 'CFNetworkFTPManager' do |ss|
  ss.source_files = 'CFNetworkFTPManager/FTPManager.{h,m}'
  end

  s.subspec 'NSURLSessionFTPManager' do |ss|
  ss.source_files = 'NSURLSessionFTPManager/CYFTPManager.{h,m}'
  end

end
