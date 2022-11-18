//
//  FeedPostService.swift
//  PosterKit
//
//  Created by Павел Барташов on 18.11.2022.
//

import Combine

public final class FeedPostService: PostService {

    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle
    //    override init(repository: PostRepositoryInterface) {
    //        super.init(repository: repository)
    //        initialize()
    //    }

    // MARK: - Metods

    //    private func initialize() {
    //        repository.setupResultsControllerStateChangedHandler { [weak self] state in
    //            switch state {
    //                case .didChangeContent:
    //                    guard let self = self else { return }
    //                    self.postSubject.send(self.repository.fetchResults)
    //
    //                default:
    //                    break
    //            }
    //        }
    //
    //    }

    public override func getPosts(filteredBy: Filter) async throws {
        try await Task.detached { [weak self] in
            if self?.mockNetworkRequstSucceeded == true {
                self?.postSubject.send(Post.demoPosts)
            } else {
                throw PostServiceError.networkFailure
            }
        }
    }
}

