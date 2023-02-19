//
//  FinalAssembly.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//
//

import UIKit

protocol IFinalAssembly {
    func assemble(with resultType: ResultType, closeAction: (() -> Void)?) -> UIViewController
}

final class FinalAssembly: IFinalAssembly {
    
    // Dependencies
    private let viewModelFactory: IFinalViewModelFactory
    private let network: INetwork
    
    // MARK: - Initialization
    
    init(
        viewModelFactory: IFinalViewModelFactory = FinalViewModelFactory(),
        network: INetwork = Network()
    ) {
        self.viewModelFactory = viewModelFactory
        self.network = network
    }
    
    // MARK: - IFinalAssembly
    
    func assemble(with resultType: ResultType, closeAction: (() -> Void)?) -> UIViewController {
        let router: FinalRouter = FinalRouter()
        let presenter: FinalPresenter = FinalPresenter(
            viewModelFactory: viewModelFactory,
            router: router,
            network: network,
            resultType: resultType,
            closeAction: closeAction
        )
        
        let viewController: FinalViewController = FinalViewController(presenter: presenter)
        presenter.view = viewController
        router.transitionHandler = viewController
        
        return viewController
    }
}
