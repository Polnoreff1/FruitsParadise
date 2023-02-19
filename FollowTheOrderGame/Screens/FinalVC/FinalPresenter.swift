//
//  FinalPresenter.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//
//

import UIKit

protocol IFinalPresenter {
    func viewDidLoad()
    func moveBack()
    var viewModel: FinalViewModel? { get }
}

final class FinalPresenter: IFinalPresenter {
    
    // Dependencies
    weak var view: IFinalViewController?
    private let viewModelFactory: IFinalViewModelFactory
    private let router: IFinalRouter
    private let network: INetwork
    private let resultType: ResultType
    private var closeAction: (() -> Void)? = { }
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: IFinalViewModelFactory,
        router: IFinalRouter,
        network: INetwork,
        resultType: ResultType,
        closeAction: (() -> Void)?
    ) {
        self.viewModelFactory = viewModelFactory
        self.router = router
        self.network = network
        self.resultType = resultType
        self.closeAction = closeAction
    }
    
    // MARK: - IFinalPresenter
    
    var viewModel: FinalViewModel?
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        switch resultType {
        case .win:
            getWish { wishText in
                self.viewModel = self.viewModelFactory.makeViewModel(
                    with: .win,
                    message: wishText
                )
                if let viewModel = self.viewModel {
                    self.view?.setup(with: viewModel)
                    self.view?.hideActivityIndicator()
                }
            }
        case .loss:
            viewModel = viewModelFactory.makeViewModel(
                with: .loss,
                message: nil
            )
            if let viewModel {
                view?.setup(with: viewModel)
                view?.hideActivityIndicator()
            }
        }
        if let viewModel {
            view?.setup(with: viewModel)
        }
    }
    
    func moveBack() {
        router.moveBack()
        if let closeAction {
            closeAction()
        }
    }
    
    private func getWish(closure: @escaping (String) -> ()) {
        network.getWish { wish in
            closure(wish.fortune)
        }
    }
}
