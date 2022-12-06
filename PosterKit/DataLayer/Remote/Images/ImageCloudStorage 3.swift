//
//  ImageCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 25.11.2022.
//

import FirebaseStorage

public protocol ImageCloudStorageProtocol {
    func store(imageData data: Data, forId uid: String) async throws
    func getImageData(byId uid: String) async throws -> Data?
}

public final class ImageCloudStorage: ImageCloudStorageProtocol {

    // MARK: - Properties

    private let storage = Storage.storage()
    private var imagesRef: StorageReference {
        storage.reference().child(Constants.Cloud.postImagesStorage)
    }

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    private func getImageRef(for uid: String) -> StorageReference {
        imagesRef.child("\(uid).jpg")
    }

    public func store(imageData data: Data, forId uid: String) async throws {
        let imageRef = getImageRef(for: uid)

        print(imageRef.bucket)

        _ = try await imageRef.putDataAsync(data)


//        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//            }
//            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
//            // You can also access to download URL after upload.
//            riversRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
//            }
//        }
    }

    public func getImageData(byId uid: String) async throws -> Data? {
        let imageRef = getImageRef(for: uid)
        return try await imageRef.data(maxSize: Constants.Cloud.maxSizeToDownload)
    }
}



