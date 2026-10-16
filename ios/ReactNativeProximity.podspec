require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name = 'ReactNativeProximity'
  s.version = package['version']
  s.summary = package['description']
  s.homepage = package['homepage']
  s.license = package['license']
  s.author = 'song-react'
  s.source = { git: package['repository']['url'] }
  s.platform = :ios, '16.4'
  s.swift_version = '5.9'
  s.static_framework = true
  s.source_files = '**/*.swift'
  s.dependency 'ExpoModulesCore'
end
