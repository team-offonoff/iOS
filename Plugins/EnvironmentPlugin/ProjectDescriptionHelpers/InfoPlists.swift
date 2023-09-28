import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.offonoff-AB.release",
        "CFBundleDisplayName": "AB",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "Pretendard-Black.otf",
            "Item 1": "Pretendard-Bold.otf",
            "Item 2": "Pretendard-ExtraBold.otf",
            "Item 5": "Pretendard-Medium.otf",
            "Item 6": "Pretendard-Regular.otf",
            "Item 7": "Pretendard-SemiBold.otf",
        ],
        "App Transport Security Settings": ["Allow Arbitrary Loads": true],
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "ITSAppUsesNonExemptEncryption": false,
        "NSPhotoLibraryUsageDescription": "갤러리 권한 작성하기"
    ]
    
    static let demoInfoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0.0",
      "CFBundleDevelopmentRegion": "ko",
      "CFBundleVersion": "1",
      "CFBundleIdentifier": "com.offonoff-AB.test",
      "CFBundleDisplayName": "AB-Test",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false,
          "UISceneConfigurations": [
              "UIWindowSceneSessionRoleApplication": [
                  [
                      "UISceneConfigurationName": "Default Configuration",
                      "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                  ],
              ]
          ]
      ],
      "UIAppFonts": [
          // FIXME: - 폰트 추가 후 수정
          //                "Item 0": "Pretendard-Black.otf",
          //                "Item 1": "Pretendard-Bold.otf",
          //                "Item 2": "Pretendard-ExtraBold.otf",
          //                "Item 3": "Pretendard-ExtraLight.otf",
          //                "Item 4": "Pretendard-Light.otf",
          //                "Item 5": "Pretendard-Medium.otf",
          //                "Item 6": "Pretendard-Regular.otf",
          //                "Item 7": "Pretendard-SemiBold.otf",
          //                "Item 8": "Pretendard-Thin.otf"
      ],
      "App Transport Security Settings": ["Allow Arbitrary Loads": true],
      "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
      "ITSAppUsesNonExemptEncryption": false,
      "NSPhotoLibraryUsageDescription": "갤러리 권한"
  ]
}
