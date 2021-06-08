# react-native-dsphoto-module

Native Photo Editor Wrapper

## Installation

```sh
npm install react-native-dsphoto-module
```

iOS
iOS Prerequisite: Please make sure CocoaPods is installed on your system
- Add the following to your `Podfile` -> `ios/Podfile` and run pod update:
  use_native_modules!

  use_frameworks! :linkage => :static

  pod 'iOSPhotoEditor', :git => 'https://github.com/prscX/photo-editor', :branch => 'master'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name.include?('iOSPhotoEditor')
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '5'
        end
      end
    end
  end

  $static_framework = ['FlipperKit', 'Flipper', 'Flipper-Folly',
    'CocoaAsyncSocket', 'ComponentKit', 'Flipper-DoubleConversion',
    'Flipper-Glog', 'Flipper-PeerTalk', 'Flipper-RSocket', 'Yoga', 'YogaKit',
    'CocoaLibEvent', 'OpenSSL-Universal', 'boost-for-react-native']
  
  pre_install do |installer|
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
    installer.pod_targets.each do |pod|
        if $static_framework.include?(pod.name)
          def pod.build_type;
            Pod::BuildType.static_library
          end
        end
        if pod.name.eql?('RNReanimated')
          puts "Link #{pod.name} as static_library"
          def pod.build_type;
            Pod::BuildType.static_library
          end
        end
      end
  end


Add below property to your info.list

	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>Application needs permission to write photos...</string>

	<!-- If you are targeting devices running on iOS 10 or later, you'll also need to add: -->
	<key>NSPhotoLibraryUsageDescription</key>
	<string>iOS 10 needs permission to write photos...</string>
  
  
Android

Please add below script in your build.gradle

buildscript {
    repositories {
        maven { url "https://jitpack.io" }
        ...
    }
}

allprojects {
    repositories {
        maven { url "https://jitpack.io" }
        ...
    }
}
Add below activity in your app activities:
<activity android:name="com.ahmedadeltito.photoeditor.PhotoEditorActivity" /> <activity android:name="com.yalantis.ucrop.UCropActivity" />

To save image to the public external storage, you must request the WRITE_EXTERNAL_STORAGE permission in your manifest file:
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

## Usage

```js
import DsphotoModule from "react-native-dsphoto-module";

// ...

DsphotoModule.Edit(photo.path, (res) => {
            console.log(`editor-path: ${res}`);
          },
          (error) => {
            console.log(`action: ${error} `);
          })
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
