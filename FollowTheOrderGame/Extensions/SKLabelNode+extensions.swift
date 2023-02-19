//
//  SKLabelNode+extensions.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import Foundation
import SpriteKit

extension SKLabelNode {
    func renderEmoji(_ emoji: Character) {
        fontSize = 50
        text = String(emoji)
        
        verticalAlignmentMode = .center
        horizontalAlignmentMode = .center
    }
}
