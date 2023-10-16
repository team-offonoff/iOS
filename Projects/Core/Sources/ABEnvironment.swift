//
//  ABEnvironment.swift
//  Core
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct ABEnvironment {
    public static let kakaoAppKey: String = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
}
