//
//  CastleNode.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class CastleNode: SKShapeNode, Damageable {
    let maxHP: CGFloat = GameConfig.castleHP
    var hp: CGFloat = GameConfig.castleHP

    init(size: CGSize, team: Team) {
        super.init()
        let rect = CGRect(origin: .zero, size: size)
        path = CGPath(rect: rect, transform: nil)
        fillColor = (team == .player) ? .blue.withAlphaComponent(0.35) : .red.withAlphaComponent(0.35)
        strokeColor = .black
        lineWidth = 2
        self.team = team

        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.castle
        physicsBody?.contactTestBitMask = PhysicsCategory.mob | PhysicsCategory.hero
        physicsBody?.collisionBitMask = 0
    }

    required init?(coder: NSCoder) { fatalError() }

    func isDestroyed() -> Bool { hp <= 0 }
}
