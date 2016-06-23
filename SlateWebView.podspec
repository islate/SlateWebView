
Pod::Spec.new do |s|

  s.name         = "SlateWebView"
  s.version      = "3.4.2.1"
  s.summary      = "A UIWebView intergrated SlateURI and SlateWebridge."


  s.description  = <<-DESC
       A UIWebView intergrated SlateURI and SlateWebridge. And other helper functions.  
  
                   DESC

  s.homepage     = "https://github.com/islate/SlateWebView"
  s.license      = "Apache 2.0"
  s.author       = { "linyize" => "linyize@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/islate/SlateWebView.git", :tag => s.version.to_s }

  s.source_files = 'SlateWebView/*.{h,m}'
  s.dependency 'SlateWebridge'
  s.dependency 'SlateURI'

end
