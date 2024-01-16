//
//  Profile.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public enum Profile {
    public enum Image {
        public enum Action: CaseIterable, Identifiable {
            case takePicture
            case gallery
            case delete
        }
    }
}
