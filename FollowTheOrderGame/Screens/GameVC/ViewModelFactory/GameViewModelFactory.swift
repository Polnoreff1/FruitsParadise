//
//  GameViewModelFactory.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import UIKit

protocol IGameViewModelFactory {
    func makeViewModel() -> GameViewModel
}

final class GameViewModelFactory: IGameViewModelFactory {
    
    func makeViewModel() -> GameViewModel {
        let viewModel: GameViewModel = GameViewModel()
        return viewModel
    }
}
