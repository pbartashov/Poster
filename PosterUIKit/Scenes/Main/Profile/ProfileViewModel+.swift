//
//  ProfileViewModel+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 01.11.2022.
//

import UIKit
import UniformTypeIdentifiers
import PosterKit

protocol DragDropProtocol {
    func dragItems(for indexPath: IndexPath) -> [UIDragItem]
    func canHandle(_ session: UIDropSession) -> Bool
    func handle(dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal
    func handle(performDropWith coordinator: UITableViewDropCoordinator, completion: @escaping () -> Void)
}

//https://developer.apple.com/documentation/uikit/drag_and_drop/adopting_drag_and_drop_in_a_table_view
extension ProfileViewModel: DragDropProtocol {

    // MARK: - Drag

    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let post = posts[indexPath.row]

        let textData = post.content.data(using: .utf8)
        let textItemProvider = NSItemProvider()
        textItemProvider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier,
                                                    visibility: .all
        ) { completion in
            completion(textData, nil)
            return nil
        }

        var dragItems = [
            UIDragItem(itemProvider: textItemProvider)
        ]
        guard let image = post.imageData?.asImage else { return dragItems }

        let imageProvider = NSItemProvider(object: image)
        dragItems.append(
            UIDragItem(itemProvider: imageProvider)
        )

        return dragItems
    }

    // MARK: - Drop

    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self) &&
        session.canLoadObjects(ofClass: UIImage.self)
    }

    func handle(dropSessionDidUpdate session: UIDropSession,
                withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        guard session.items.count == 2 else {
            return UITableViewDropProposal(operation: .cancel)
        }

        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func handle(performDropWith coordinator: UITableViewDropCoordinator, completion: @escaping () -> Void) {
        let destinationIndex: Int

        if let indexPath = coordinator.destinationIndexPath {
            destinationIndex = indexPath.row
        } else {
            destinationIndex = posts.count
        }

        var dropDescription: String?
        var dropImage: UIImage?

        func createAndInsertPost() {
            guard let description = dropDescription,
                  let image = dropImage else {
                return
            }

            let newPost = Post(uid: UUID().uuidString,
                               timestamp: .now,
                               authorId: userViewModel?.user.uid ?? "",
                               content: description)
            let postViewModel = PostViewModel(from: newPost)
            postViewModel.imageData = image.asImageData

            perfomAction(.insert((postViewModel, destinationIndex)))

            completion()
        }

        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            if let text = items.first as? String {
                dropDescription = text
                createAndInsertPost()
            }
        }

        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            if let image = items.first as? UIImage {
                dropImage = image
                createAndInsertPost()
            }
        }
    }
}
