//
//  MainGameViewController.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 19.02.2023.
//

import UIKit
import SpriteKit
import GameplayKit

protocol IGameViewController: AnyObject { }

final class GameViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var startView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    
    private var presenter: IGamePresenter
    private var timer = Timer()
    private var score = 5 {
        didSet {
            presenter.saveScore(value: score, key: "Score")
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    init(presenter: IGamePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Private Methods
    
    private func setupScene() {
        if let view = self.view as? SKView? {
            let scene = createAnotherScene()
            scene.scaleMode = .resizeFill
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    private func createAnotherScene() -> SKScene {
        let minimumDimension = min(view.frame.width, view.frame.height)
        let size = CGSize(width: minimumDimension, height: minimumDimension)
        let scene = SKScene(size: size)
        if let sceneColor = UIColor(named: "gameBG") {
            scene.backgroundColor = sceneColor
        }
        addEmoji(to: scene)
        presenter.currentEmojis = scene.children.shuffled()
        animateNodes(presenter.currentEmojis)
        return scene
    }
    
    private func addEmoji(to scene: SKScene) {
        let distance = floor(scene.size.height / CGFloat(presenter.allEmoji.count)) + 25
        
        var currentRandomElements: Set<Character> = []
        
        while currentRandomElements.count != score {
            if let randomItem = presenter.allEmoji.randomElement() {
                currentRandomElements.insert(randomItem)
            }
        }
        
        var emojiArray: [Character] = []
        
        currentRandomElements.forEach { uniqEmoji in
            emojiArray.append(uniqEmoji)
        }
        
        for (index, emoji) in emojiArray.enumerated() {
            let node = SKLabelNode()
            node.renderEmoji(emoji)
            
            let positionX = index % 2 == 0 ? scene.size.width / 2 + 55 : scene.size.width / 2 - 55
            node.position.y = distance * (CGFloat(index) + 2.5)
            node.position.x = positionX
            node.name = String(emoji)
            
            scene.addChild(node)
        }
    }
    
    private func animateNodes(_ nodes: [SKNode]) {
        for (index, node) in nodes.enumerated() {
            let delayAction = SKAction.wait(forDuration: TimeInterval(index) * 0.6)
            
            let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.3)
            let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
            let waitAction = SKAction.wait(forDuration: 1)
            let waitBetweenAction = SKAction.wait(forDuration: 1)
            
            let scaleActionSequence = SKAction.sequence(
                [
                    waitAction,
                    scaleUpAction,
                    scaleDownAction,
                    waitBetweenAction
                ]
            )
            
            let repeatAction = SKAction.repeat(scaleActionSequence, count: 1)
            let actionSequence = SKAction.sequence([delayAction, repeatAction])
            node.run(actionSequence)
        }
    }
    
    private func setupUI() {
        setupStartView()
        scoreLabel.text = ""
        score = presenter.getValueFor(key: "Score")
    }
    
    private func setupStartView() {
        startView.backgroundColor = .white.withAlphaComponent(0.8)
        startButton.layer.cornerRadius = startButton.layer.bounds.height / 2
        startButton.isEnabled = true
    }
    
    private func showFinalVC(result: ResultType, closeAction: (() -> Void)?) {
        presenter.showFinalScreen(result: result, closeAction: closeAction)
    }
    
    private func updateScore(score: Int) {
        self.scoreLabel.text = "Ваш текущий счет: \(score)"
    }
    
    private func resetScene(score: Int, result: ResultType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            self.showFinalVC(result: result) {
                self.presenter.selectedEmojis.removeAll()
                self.score = score
                self.setupScene()
                self.updateScore(score: self.score)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func update() {
        timerLabel.textColor = UIColor(named: "startColor")
        timerLabel.font = .systemFont(ofSize: 70, weight: .heavy)
        if presenter.timeCount > 0 {
            let seconds = String(presenter.timeCount % 60)
            timerLabel.text = seconds
            presenter.timeCount -= 1
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.1) {
                self.startView.alpha = 0
            } completion: { isFinished in
                if isFinished {
                    self.startView.removeFromSuperview()
                    self.timer.invalidate()
                    self.setupScene()
                    self.scoreLabel.text = "Ваш текущий счет: \(self.score)"
                }
            }
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func startButtonAction(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        startButton.isEnabled = false
    }
}

// MARK: - Extensions

extension GameViewController: IGameViewController { }

extension GameViewController: SKSceneDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let view = self.view as? SKView?, let scene = view?.scene  {
                let location = touch.location(in: scene)
                let node: SKNode = scene.atPoint(location)
                if node.name != nil {
                    if let explosion = SKEmitterNode(fileNamed: "CorrectSpark") {
                        explosion.position = node.position
                        let explodeAction = SKAction.run {
                            scene.addChild(explosion)
                        }
                        let waitAction = SKAction.wait(forDuration: 0.3)
                        let removeExplodeAction = SKAction.run {
                            explosion.removeFromParent()
                        }
                        let colorizeAction = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0.2)
                        
                        let explodeSequence = SKAction.sequence(
                            [
                                explodeAction,
                                colorizeAction,
                                waitAction,
                                removeExplodeAction,
                            ]
                        )
                        node.run(explodeSequence)
                    }
                    
                    presenter.selectedEmojis.append(node)
                    
                    if
                        presenter.selectedEmojis.count == 1,
                        presenter.currentEmojis.first != presenter.selectedEmojis.first {
                        resetScene(score: presenter.defaultScore, result: .loss)
                    } else if presenter.selectedEmojis.count == presenter.currentEmojis.count && presenter.currentEmojis.contains(presenter.selectedEmojis) {
                        score += 1
                        resetScene(score: score, result: .win)
                    } else if !presenter.currentEmojis.contains(presenter.selectedEmojis) {
                        resetScene(score: presenter.defaultScore, result: .loss)
                    }
                }
            }
        }
    }
}
