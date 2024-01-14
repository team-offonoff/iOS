//
//  Job.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public enum Job: String, CaseIterable {
    case marketer = "마케터"
    case developer = "개발자"
    case planner = "기획자"
    case jobSeeker = "취업준비생"
    case designer = "디자이너"
    case student = "학생"
    case selfEmployed = "자영업자"
    case camerist = "사진가"
    case etc = "기타"
}
