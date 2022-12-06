//
//  StoryViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 05.12.2022.
//

public final class StoryViewModel {

    // MARK: - Properties

    private let storageReader: StorageReaderProtocol?

    @Published public var authorAvatarData: Data?
    @Published public var author: User?

    public let story: Story
    public var description: String? { story.description }

    // MARK: - LifeCicle

    public init(from story: Story,
                storageReader: StorageReaderProtocol? = nil
    ) {
        self.story = story
        self.storageReader = storageReader
    }

    // MARK: - Metods

    public func fetchData() {
        Task {
            guard
                let storageReader = storageReader,
                let user = try? await storageReader.getUser(byId: story.authorId)
            else {
                return
            }

            author = user
            authorAvatarData = user.avatarData
        }
    }
}

extension StoryViewModel: Hashable {
    public static func == (lhs: StoryViewModel, rhs: StoryViewModel) -> Bool {
        lhs.story == rhs.story
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(story)
    }
}
