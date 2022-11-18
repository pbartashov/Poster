//
//  FavoritesPostService.swift
//  PosterKit
//
//  Created by Павел Барташов on 18.11.2022.
//

public final class FavoritesPostService: PostService {

    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle
    public override init(repository: PostRepositoryInterface) {
        super.init(repository: repository)
        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        repository.setupResultsControllerStateChangedHandler { [weak self] state in
            switch state {
                case .didChangeContent:
                    guard let self = self else { return }
                    self.postSubject.send(self.repository.fetchResults)

                default:
                    break
            }
        }

    }

    public override func getPosts(filteredBy filter: Filter) async throws {
//        Task { [weak self] in
//            guard let self = self else { return }
//            do {
                var predicate: NSPredicate? = nil
                if let text = filter.authorName {
                    predicate = NSPredicate(format: "author CONTAINS[c] %@", text)
                }
                try self.repository.startFetchingWith(predicate: predicate,
                                                                   sortDescriptors: nil)

//                self.posts = self.favoritesPostRepository.fetchResults
//            } catch {
//                self.errorPresenter.show(error: error)
//            }
//        }
    }
}
