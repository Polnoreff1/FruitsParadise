//
//  GameVcAssembly.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import Foundation
import UIKit

protocol IGameVcAssembly {
    func assemble() -> UIViewController
}

final class GameVcAssembly: IGameVcAssembly {
    
    // Dependencies
    private let finalAssembly: IFinalAssembly
    private let udStorage: IUDStorage
    
    // MARK: - Initialization
    
    init(
        finalAssembly: IFinalAssembly = FinalAssembly(),
        udStorage: IUDStorage = UDStorage()
    ) {
        self.finalAssembly = finalAssembly
        self.udStorage = udStorage
    }
    
    // MARK: - IStartAssembly
    
    func assemble() -> UIViewController {
        let router: GameRouter = GameRouter(finalAssembly: finalAssembly)
        
        let presenter: GamePresenter = GamePresenter(
            router: router,
            udStorage: udStorage
        )
        
        let viewController: GameViewController = GameViewController(presenter: presenter)
        
        presenter.view = viewController
        router.transitionHandler = viewController
        
        return viewController
    }
}

