//
//  GamePresenter.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import UIKit
import SpriteKit

protocol IGamePresenter {
    func showFinalScreen(result: ResultType, closeAction: (() -> Void)?)
    func saveScore(value: Int, key: String)
    func getValueFor(key: String) -> Int
    var allEmoji: [Character] { get }
    var timeCount: Int { get set }
    var currentEmojis: [SKNode] { get set }
    var selectedEmojis: [SKNode] { get set }
    var defaultScore: Int { get }
}

final class GamePresenter: IGamePresenter {
    
    // Dependencies
    weak var view: IGameViewController?
    private let router: IGameRouter
    private let udStorage: IUDStorage
    
    // MARK: - Initialization
    
    init(
        router: IGameRouter,
        udStorage: IUDStorage
    ) {
        self.router = router
        self.udStorage = udStorage
    }
    
    // MARK: - IStartPresenter
    
    var allEmoji: [Character] = ["🍊", "🍋", "🍑", "🥭", "🥑", "🍌", "🍒", "🍓", "🍈", "🍎", "🍏", "🥥", "🍍", "🥝", "🍐", "🍅", "🍇", "🫐", "🌽", "🥕"]
    var timeCount = 3
    var currentEmojis: [SKNode] = []
    var selectedEmojis: [SKNode] = []
    var defaultScore = 5
    
    func showFinalScreen(result: ResultType, closeAction: (() -> Void)?) {
        router.showFinalScreen(result: result, closeAction: closeAction)
    }
   
    func saveScore(value: Int, key: String) {
        udStorage.set(value, forKey: key)
    }
    
    func getValueFor(key: String) -> Int {
        if let savedScore: Int = udStorage.value(forKey: key) {
            return savedScore
        } else {
            return 5
        }
    }
}

