//
//  FinalViewModelFactory.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//
//

import UIKit

protocol IFinalViewModelFactory {
    func makeViewModel(
        with result: ResultType,
        message: String?
    ) -> FinalViewModel
}

final class FinalViewModelFactory: IFinalViewModelFactory {
    
    func makeViewModel(
        with result: ResultType,
        message: String?
    ) -> FinalViewModel {
        var buttonText = ""
        var titleText = ""
        var backgroundImage: UIImage?
        switch result {
        case .win:
            buttonText = "Продолжить игру"
            titleText = "Вы победили! \n Вот ваше пожелание:"
            backgroundImage = UIImage(named: "winImage")
        case .loss:
            buttonText = "Попробовать снова"
            titleText = "Oooops \n О нет, вы проиграли("
            backgroundImage = UIImage(named: "lossImage")
        }
        let viewModel: FinalViewModel = FinalViewModel(
            buttonText: buttonText,
            messageText: message,
            titleText: titleText,
            backgroundImage: backgroundImage
        )
        return viewModel
    }
}
