////
////  PublishedViewModel.swift
////  PosterKit
////
////  Created by Павел Барташов on 17.11.2022.
////
//
//import Combine
//
//public protocol PublishedViewModelProtocol {
//    associatedtype State
//    associatedtype Action
//
//    var errorPresenter: ErrorPresenterProtocol { get }
//    var statePublisher: Published<State>.Publisher { get }
//
//    func perfomAction(_ action: Action)
//}
//
//public class PublishedViewModel<State, Action>: PublishedViewModelProtocol {
//
//    //MARK: - Properties
//
//    public let errorPresenter: ErrorPresenterProtocol
//
//    @Published var state: State
//    public var statePublisher: Published<State>.Publisher
//
//    //MARK: - LifeCicle
//
//    public init(state: State, errorPresenter: ErrorPresenterProtocol) {
//        self.state = state
//        self.errorPresenter = errorPresenter
//    }
//
//    //MARK: - Metods
//
//    public func perfomAction(_ action: Action) { }
//}
