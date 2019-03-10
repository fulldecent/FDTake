Pod::Spec.new do |s|
  s.name         = "FDTake"
  s.version      = "2.0.3"
  s.summary      = "Easily take a photo or video or choose from library. Also user can personalize edit cropping"
  s.description  = <<-DESC
                   `FDTake` helps you quickly have the user take or choose an existing photo or video.
                   DESC
  s.homepage     = "https://github.com/fulldecent/FDTake"
  s.screenshots  = "https://i.imgur.com/SpSJzmS.png"
  s.license      = "MIT"
  s.author       = { "William Entriken" => "github.com@phor.net" }
  s.source       = { :git => "https://github.com/fulldecent/FDTake.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/fulldecent'
  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Source/*.{h,m,swift}','Source/*.swift'
  s.resource  = 'Source/*.lproj/*'
end
