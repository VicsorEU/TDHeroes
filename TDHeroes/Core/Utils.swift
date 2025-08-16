//
//  Utils.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import CoreGraphics
import SpriteKit

func clamp<T: Comparable>(_ x: T, _ a: T, _ b: T) -> T { max(a, min(b, x)) }

extension SKNode {
    // Храним команду (player/enemy) в userData
    var team: Team? {
        get {
            if let raw = userData?["team"] as? String {
                return raw == "player" ? .player : .enemy
            }
            return nil
        }
        set {
            if userData == nil { userData = NSMutableDictionary() }
            userData?["team"] = (newValue == .player) ? "player" : "enemy"
        }
    }
}

extension CGFloat {
    var asFloat: Float { Float(self) }
}
