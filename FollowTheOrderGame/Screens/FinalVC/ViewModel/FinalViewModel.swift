//
//  FinalViewModel.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//
//

import UIKit

struct FinalViewModel {
    let buttonText: String
    let messageText: String?
    let titleText: String
    let backgroundImage: UIImage?
}

enum ResultType {
    case win
    case loss
}
