//
//  TowerNode.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class TowerNode: SKShapeNode, Damageable {
    let maxHP: CGFloat = 250
    var hp: CGFloat = 250
    var level: Int = 1
    var lastShotTime: TimeInterval = 0
    var baseDamage: CGFloat = GameConfig.towerDamage
    var fireRate: CGFloat = GameConfig.towerFireRate
    var range: CGFloat = GameConfig.towerRange
    var ownerTeam: Team = .player

    init(size: CGSize, team: Team) {
        super.init()
        let rect = CGRect(origin: .zero, size: size)
        path = CGPath(rect: rect, transform: nil)
        fillColor = .cyan.withAlphaComponent(0.45)
        strokeColor = .black
        lineWidth = 2
        ownerTeam = team
        self.team = team

        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.tower
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.mob | PhysicsCategory.hero
    }

    required init?(coder: NSCoder) { fatalError() }

    func damageNow() -> CGFloat {
        baseDamage * pow(GameConfig.towerUpgradeMultiplier, CGFloat(level-1))
    }

    func upgrade() {
        level += 1
        hp = min(maxHP, hp + 30)
    }
}
