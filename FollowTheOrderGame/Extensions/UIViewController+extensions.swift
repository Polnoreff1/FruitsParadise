//
//  UIViewController+extensions.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func addChildViewController(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChildViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
    
extension UIViewController {
    func showAllert(title: String, message: String, titleConfirmAction: String, completion: (() -> Void)?) {
        showAllert(
            title: title,
            message: message,
            titleConfirmAction: titleConfirmAction,
            okCompletion: completion,
            titleCancelAction: nil,
            cancelCompletion: nil
        )
    }
    
    func showAllert(
        title: String,
        message: String,
        titleConfirmAction: String,
        okCompletion: (() -> Void)?,
        titleCancelAction: String?,
        cancelCompletion: (() -> Void)?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let confirmAction = UIAlertAction(
            title: titleConfirmAction,
            style: UIAlertAction.Style.default
        ) { _ in
            okCompletion?()
        }
        alertController.addAction(confirmAction)
        if let titleCancelAction = titleCancelAction {
            let cancelAction = UIAlertAction(
                title: titleCancelAction,
                style: UIAlertAction.Style.cancel
            ) { _ in
                cancelCompletion?()
            }
            alertController.addAction(cancelAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}

