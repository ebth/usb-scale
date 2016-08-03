Gem::Specification.new do |s|
  s.name        = 'usb-scale'
  s.version     = '0.0.1'
  s.date        = '2016-07-22'
  s.summary     = "Read input from a Dymo USB scale"
  s.description = "Read input from a Dymo USB scale"
  s.authors     = ["Josh Becker", "Bobby Uhlenbrock"]
  s.email       = 'developers@ebth.com'
  s.files       = ["lib/scale.rb", "lib/scale/output.rb"]
  s.homepage    = 'http://rubygems.org/gems/usb-scale'
  s.license     = 'Apache-2.0'

  s.add_dependency "hid_api", "0.1.1"
  s.add_development_dependency "pry", "0.10.3"
  s.add_development_dependency "rspec", "3.5.0"
end
