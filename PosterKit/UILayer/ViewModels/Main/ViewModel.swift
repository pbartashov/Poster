//
//  ViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 03.07.2022.
//

public protocol ViewModelProtocol {
    associatedtype State
    associatedtype Action

    var errorPresenter: ErrorPresenterProtocol { get }
    var statePublisher: Published<State>.Publisher { get }

    func perfomAction(_ action: Action)
}

public class ViewModel<State, Action>: ViewModelProtocol {

    //MARK: - Properties

    public let errorPresenter: ErrorPresenterProtocol

    @Published var state: State

    public var statePublisher: Published<State>.Publisher { $state }

    //MARK: - LifeCicle

    public init(state: State, errorPresenter: ErrorPresenterProtocol) {
        self.state = state
        self.errorPresenter = errorPresenter
    }

    //MARK: - Metods

    public func perfomAction(_ action: Action) { }
}
