# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'Legion' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for Legion
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Masonry'

  target 'LegionTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'OCMock'
    pod 'Expecta'
  end

end

# Disable Code Coverage for Pods projects
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
end
