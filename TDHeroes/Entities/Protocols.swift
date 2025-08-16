//
//  Damageable.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//

//И тут изменение


import SpriteKit

// Унифицированный интерфейс "то, у чего есть здоровье"
protocol Damageable: AnyObject {
    var maxHP: CGFloat { get }
    var hp: CGFloat { get set }
    func applyDamage(_ amount: CGFloat)
}

extension Damageable where Self: SKNode {
    func applyDamage(_ amount: CGFloat) {
        hp = max(0, hp - amount)
    }
}
