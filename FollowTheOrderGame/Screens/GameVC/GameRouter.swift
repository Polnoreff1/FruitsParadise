//
//  GameRouter.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import UIKit

protocol IGameRouter {
    func showFinalScreen(result: ResultType, closeAction: (() -> Void)?)
}

final class GameRouter: IGameRouter {
    
    weak var transitionHandler: UIViewController?
    private let finalAssembly: IFinalAssembly
    
    init(finalAssembly: IFinalAssembly) {
        self.finalAssembly = finalAssembly
    }
    
    func showFinalScreen(result: ResultType, closeAction: (() -> Void)?) {
        let finalAssembly = FinalAssembly()
        let finalVC = finalAssembly.assemble(with: result, closeAction: closeAction)
        finalVC.modalPresentationStyle = .fullScreen
        transitionHandler?.present(finalVC, animated: true)
    }
}
