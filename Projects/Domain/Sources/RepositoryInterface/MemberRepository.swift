//
//  MemberRepository.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/07.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public protocol MemberRepository: Repository{
    func fetchProfile() -> NetworkResultPublisher<Profile?>
    func modifyProfile(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?>
    func modifyProfile(image: UIImage) async -> NetworkResultPublisher<Any?>
    func deleteProfileImage() -> NetworkResultPublisher<Any?>
}
