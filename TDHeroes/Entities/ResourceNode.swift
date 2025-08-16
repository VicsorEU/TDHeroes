//
//  ResourceNode.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class ResourceNode: SKShapeNode {
    let type: ResourceType

    init(type: ResourceType, size: CGSize) {
        self.type = type
        super.init()
        let rect = CGRect(origin: .zero, size: size)
        path = CGPath(rect: rect, transform: nil)
        fillColor = .yellow
        strokeColor = .black
        lineWidth = 2

        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.resource
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
    }

    required init?(coder: NSCoder) { fatalError() }
}
