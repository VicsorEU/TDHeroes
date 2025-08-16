//
//  MobNode.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class MobNode: SKShapeNode, Damageable {
    let maxHP: CGFloat
    var hp: CGFloat
    let moveSpeed: CGFloat
    let dps: CGFloat = GameConfig.mobDamagePerSecond // урон по цели рядом
    var lastAttackTime: TimeInterval = 0
    var targetCastle: CastleNode? // цель по умолчанию

    init(type: UnitType, team: Team) {
        switch type {
        case .grunt:
            maxHP = GameConfig.gruntHP; moveSpeed = GameConfig.gruntSpeed
        case .heavy:
            maxHP = GameConfig.heavyHP; moveSpeed = GameConfig.heavySpeed
        case .fast:
            maxHP = GameConfig.fastHP;  moveSpeed = GameConfig.fastSpeed
        }
        hp = maxHP
        super.init()

        let r: CGFloat = 12
        let circle = CGPath(ellipseIn: CGRect(x: -r, y: -r, width: r*2, height: r*2), transform: nil)
        path = circle
        fillColor = (team == .player) ? .green : .orange
        strokeColor = .black
        lineWidth = 1.5
        self.team = team

        physicsBody = SKPhysicsBody(circleOfRadius: r)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = 0
        physicsBody?.categoryBitMask = PhysicsCategory.mob
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.mob | PhysicsCategory.tower | PhysicsCategory.hero | PhysicsCategory.castle
    }

    required init?(coder: NSCoder) { fatalError() }

    func isDead() -> Bool { hp <= 0 }
}
