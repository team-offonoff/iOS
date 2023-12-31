import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: Plist.Value] = [
        
        //HOST
        "BASE_URL": "$(BASE_URL)",
        
        //KEY 관리
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "DEV_TOKEN": "$(DEV_TOKEN)",
        
        "CFBundleShortVersionString": "1.0.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "\(Environment.bundlePrefix).release",
        "CFBundleDisplayName": "AB",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["kakao$(KAKAO_APP_KEY)"]
            ]
        ],
        "LSApplicationQueriesSchemes": [
            "kakaokompassauth",  //카카오톡으로 로그인
            "kakaolink"
        ],
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
            "Item 3": "Pretendard-Medium.otf",
            "Item 4": "Pretendard-Regular.otf",
            "Item 5": "Pretendard-SemiBold.otf",
            "Item 6": "Montserrat-Medium.ttf"
        ],
        "App Transport Security Settings": ["Allow Arbitrary Loads": true],
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "ITSAppUsesNonExemptEncryption": false,
        "NSPhotoLibraryUsageDescription": "갤러리 권한 작성하기"
    ]
    
    static let demoInfoPlist: [String: Plist.Value] = [
        
        //HOST
        "BASE_URL": "$(BASE_URL)",
        
        //KEY 관리
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "DEV_TOKEN": "$(DEV_TOKEN)",
        
        "CFBundleShortVersionString": "1.0.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "\(Environment.bundlePrefix).test",
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
            "Item 0": "Pretendard-Black.otf",
            "Item 1": "Pretendard-Bold.otf",
            "Item 2": "Pretendard-ExtraBold.otf",
            "Item 3": "Pretendard-Medium.otf",
            "Item 4": "Pretendard-Regular.otf",
            "Item 5": "Pretendard-SemiBold.otf",
            "Item 6": "Montserrat-Medium.ttf"
        ],
        "App Transport Security Settings": ["Allow Arbitrary Loads": true],
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "ITSAppUsesNonExemptEncryption": false,
        "NSPhotoLibraryUsageDescription": "갤러리 권한"
    ]
}
