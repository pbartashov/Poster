//
//  PostServiceErrors.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

public enum PostServiceError: Error {
    case networkFailure
}

extension PostServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .networkFailure:
                return "networkErrorPostServiceErrors".localized
        }
    }
}
