//
//  PhysicsCategory.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import Foundation

// Битовые маски для физики SpriteKit
struct PhysicsCategory {
    static let none:      UInt32 = 0
    static let mob:       UInt32 = 1 << 0
    static let hero:      UInt32 = 1 << 1
    static let tower:     UInt32 = 1 << 2
    static let bullet:    UInt32 = 1 << 3
    static let castle:    UInt32 = 1 << 4
    static let resource:  UInt32 = 1 << 5
}
