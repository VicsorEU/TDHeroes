//
//  HeroNode.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class HeroNode: SKShapeNode, Damageable {
    let heroClass: HeroClass
    let maxHP: CGFloat = GameConfig.heroBaseHP
    var hp: CGFloat = GameConfig.heroBaseHP
    var range: CGFloat = GameConfig.heroRange
    var moveSpeed: CGFloat = GameConfig.heroMoveSpeed
    var lastShotTime: TimeInterval = 0

    init(heroClass: HeroClass) {
        self.heroClass = heroClass
        super.init()

        // Красная точка — герой
        let r: CGFloat = 16
        let circle = CGPath(ellipseIn: CGRect(x: -r, y: -r, width: r*2, height: r*2), transform: nil)
        path = circle
        fillColor = .red
        strokeColor = .darkGray
        lineWidth = 2

        physicsBody = SKPhysicsBody(circleOfRadius: r)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.hero
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.mob | PhysicsCategory.bullet
    }

    required init?(coder: NSCoder) { fatalError() }

    // Текущий ДПС по классу
    var dps: CGFloat {
        switch heroClass {
        case .archer:  return GameConfig.archerDPS
        case .mage:    return GameConfig.mageDPS
        case .warrior: return GameConfig.warriorDPS
        }
    }
}
