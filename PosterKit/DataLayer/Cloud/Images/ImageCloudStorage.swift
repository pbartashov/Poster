//
//  ImageCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 25.11.2022.
//

import FirebaseStorage

public protocol ImageCloudStorageProtocol {
    func store(imageData data: Data, withFileName fileName: String, to path: [String]) async throws
    func getImageData(withFileName fileName: String, in path: [String]) async throws -> Data?
    func getList(in path: [String]) async throws -> [String]
}

extension ImageCloudStorageProtocol {
    func store(imageData data: Data, withFileName fileName: String, to path: [String] = []) async throws {
        try await store(imageData: data, withFileName: fileName, to: path)
    }

    func getImageData(withFileName fileName: String, in path: [String] = []) async throws -> Data? {
        try await getImageData(withFileName: fileName, in: path)
    }
}

public final class ImageCloudStorage: ImageCloudStorageProtocol {

    // MARK: - Properties
    private let root: String
    private let fileExtension: String

    private let storage = Storage.storage()
    private var imagesRef: StorageReference {
        storage.reference().child(root)
    }

    // MARK: - LifeCicle

    public init(root: String,
                fileExtension: String
    ) {
        self.root = root
        self.fileExtension = fileExtension
    }

    // MARK: - Metods

    private func getImageRef(for fileName: String, in path: String = "") -> StorageReference {
        imagesRef.child("\(path)/\(fileName).\(fileExtension)")
    }

    public func store(imageData data: Data, withFileName fileName: String, to path: [String] = []) async throws {
        let imageRef = getImageRef(for: fileName, in: resolve(path: path))

        print(imageRef)

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

    public func getImageData(withFileName fileName: String, in path: [String] = []) async throws -> Data? {
        let imageRef = getImageRef(for: fileName, in: resolve(path: path))
        return try await imageRef.data(maxSize: Constants.Cloud.maxSizeToDownload)
    }

    public func getList(in path: [String]) async throws -> [String] {
        let imageRef = imagesRef.child(resolve(path: path))
        let fileExtensionLength = fileExtension.count + 1
        return try await imageRef.listAll()
            .items
            .map {
                String($0.name.dropLast(fileExtensionLength))
            }
    }

    private func resolve(path: [String]) -> String {
        path.joined(separator: "/")
    }
}



