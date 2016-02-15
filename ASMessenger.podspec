
Pod::Spec.new do |s|
  s.name             = "ASMessenger"
  s.version          = "0.1.0"
  s.summary          = "A lightweight and performant messenger interface that's easy to implement"
  s.description      = <<-DESC

[PRE-RELEASE] ASMessenger is a lightweight and performant messenger interface that's easy to implement. It's ideal for customer-support type conversations, such as a discussion between an Uber driver and rider.

DESC

  s.homepage         = "https://github.com/asharma-atx/ASMessenger"
  s.screenshots      = "http://i.imgur.com/UbuSILm.png"
  s.license          = 'MIT'
  s.author           = { "Amit Sharma" => "amitsharma@mac.com" }
  s.source           = { :git => "https://github.com/asharma-atx/ASMessenger.git", :tag => s.version.to_s }

  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = { 'ASMessenger' => ['Pod/Assets/**/*'] }
  s.public_header_files = 'Pod/Classes/Messenger\ View\ Controller/*.h', 'Pod/Classes/Entry/*.h', 'Pod/Classes/_Header/*.h'

end
