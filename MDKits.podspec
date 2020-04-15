#
# Be sure to run `pod lib lint MDKits.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MDKits'
  s.version          = '0.1.1'
  s.summary          = '快速开发框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift版本的快速开发框架
                       DESC

  s.homepage         = 'https://github.com/Marvin Chan/MDKits'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marvin Chan' => 'beychan@qq.com' }
  s.source           = { :git => 'https://github.com/BeyChan/MDKits.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '10.0'
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'MDKits/Classes/**/*'
  
  s.frameworks = 'UIKit'
  s.subspec 'Core' do |c|
      c.source_files = 'MDKits/Classes/Core/**/*'
  end

  
  s.subspec 'Extension' do |e|
      e.source_files = 'MDKits/Classes/Extension/**/*'
      e.dependency 'MDKits/Core'
  end
  
  s.subspec 'AutoLayout' do |l|
      l.dependency 'MDKits/Core'
      l.source_files = 'MDKits/Classes/AutoLayout/**/*'
  end
  
  s.subspec 'Custom' do |c|
      c.dependency 'MDKits/AutoLayout'
      c.dependency 'MDKits/Core'
      c.dependency 'MDKits/Extension'
      c.source_files = 'MDKits/Classes/Custom/**/*'
  end
  
  s.subspec 'Networking' do |n|
      n.dependency 'MDKits/Core'
      n.dependency 'Alamofire'
      n.dependency 'Cache'
      n.dependency 'MBProgressHUD'
      n.source_files = 'MDKits/Classes/Networking/**/*'
  end
  
  s.subspec 'Presentation' do |p|
      p.dependency 'MDKits/Extension'
      p.source_files = 'MDKits/Classes/Presentation/**/*'
  end
  
  s.subspec 'WebImage' do |w|
    w.dependency 'Kingfisher'
    w.dependency 'MDKits/Core'
    w.source_files = 'MDKits/Classes/WebImage/**/*'
  end
  
  s.subspec 'Refresh' do |r|
      r.dependency 'MJRefresh'
      r.source_files = 'MDKits/Classes/Refresh/**/*'
  end
  
end
