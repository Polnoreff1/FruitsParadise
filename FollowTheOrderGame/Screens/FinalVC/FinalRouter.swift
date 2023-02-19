//
//  FinalRouter.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//
//

import UIKit

protocol IFinalRouter {
    func moveBack()
}

final class FinalRouter: IFinalRouter {
    
    weak var transitionHandler: UIViewController?
    
    func moveBack() {
        transitionHandler?.dismiss(animated: true)
    }
}
