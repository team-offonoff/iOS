//
//  PresignedImageRepository.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public enum ImageBucket {
    case profile
    case topic
}

public protocol PresignedImageRepository: Repository {
    func upload(bucket: ImageBucket, request: UIImage) async throws -> String
}
