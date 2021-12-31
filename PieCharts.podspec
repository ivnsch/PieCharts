Pod::Spec.new do |s|
  s.name = "PieCharts"
  s.version = "0.0.9"
  s.summary = "Easy to use and highly customizable pie charts library for iOS"
  s.homepage = "https://github.com/i-schuetz/PieCharts"
  s.license = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.authors = "Ivan Schuetz"
  s.ios.deployment_target = "8.0"
  s.source = { :git => "https://github.com/i-schuetz/PieCharts.git", :tag => s.version }
  s.source_files = 'Sources/PieCharts/*.swift', 'Sources/PieCharts/**/*.swift'
  s.frameworks = "Foundation", "UIKit", "CoreGraphics"
end
