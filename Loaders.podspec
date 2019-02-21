Pod::Spec.new do |s|
  s.name = 'Loaders'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Simple μFramework for loading Storyboard and Xib files for iOS.'
  s.description = <<-DESC
Loaders is a simple way to define all your storyboard's UIViewControllers and NIB reusables (UITableViewCell, UICollectionViewCell, UICollectionReusableView) in clean, declarative way. It brings autocomplete and compile time checking for storyboards and xib files.
                   DESC

  s.homepage = 'https://github.com/dgrzeszczak/Loaders'
  s.authors = { 'Dariusz Grzeszczak' => 'dariusz.grzeszczak@interia.pl' }
  s.source = { :git => 'https://github.com/dgrzeszczak/Loaders.git', :tag => s.version }

  s.ios.deployment_target = '9.3'

  s.swift_version = '4.2'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '4.2',
  }

  s.requires_arc = true
  s.source_files = 'Loaders/Sources/**/*.swift'
end
