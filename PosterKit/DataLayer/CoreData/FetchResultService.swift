//
//  FetchResultService.swift
//  StorageService
//
//  Created by Павел Барташов on 09.09.2022.
//

import CoreData
import Combine

//https://www.mattmoriarity.com/observing-core-data-changes-with-combine/creating-pipelines/
final class FetchResultService: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    private let onObjectsChange = CurrentValueSubject<[NSFetchRequestResult], Never>([])

    var objects: AnyPublisher<[NSFetchRequestResult], Never> {
        onObjectsChange.eraseToAnyPublisher()
    }

    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let context: NSManagedObjectContext

    // MARK: - LifeCicle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Metods

    private func sendCurrentObjects() {
        self.onObjectsChange.send(self.fetchedResultsController?.fetchedObjects ?? [])
    }

    func startFetching(with request: NSFetchRequest<NSFetchRequestResult>,
                       sectionNameKeyPath: String? = nil) throws {
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: nil)
        controller.delegate = self

        do {
            try controller.performFetch()
        } catch {
            throw DatabaseError.error(desription: "Failed to fetch entities: \(error)")
        }

        fetchedResultsController = controller
        sendCurrentObjects()
    }

    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendCurrentObjects()
    }
}
