//
//  MemberRepository.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/07.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol MemberRepository: Repository{
    func modifyInformation(request: ModifyMemberInformationUseCaseRequestValue) -> NetworkResultPublisher<Any?>
//    func modifyProfileImage() -> NetworkResultPublisher<Any?>
//    func deleteProfileImage() -> NetworkResultPublisher<Any?>
}
