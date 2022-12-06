//
//  Gender.swift
//  PosterKit
//
//  Created by Павел Барташов on 27.11.2022.
//

public enum Gender: String, Codable {
    case male
    case female

    public var title: String {
        switch self {
            case .male:
                return "maleGender".localized

            case .female:
                return "femaleGender".localized
        }
    }
}
