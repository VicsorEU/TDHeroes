//
//  GameConfig.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import CoreGraphics
import Foundation     // ← нужно для TimeInterval

enum GameConfig {
    // Размеры и зоны
    static let lanePadding: CGFloat = 16
    static let halfDividerHeight: CGFloat = 4

    // Замки
    static let castleHP: CGFloat = 1000

    // Герои
    static let heroBaseHP: CGFloat = 180
    static let heroRange: CGFloat = 160
    static let heroMoveSpeed: CGFloat = 200 // pt/s

    // Классы героев (секундный урон / особенности)
    static let archerDPS: CGFloat = 35
    static let mageDPS: CGFloat = 22 // AoE
    static let warriorDPS: CGFloat = 55 // ближний

    // Мобы
    static let gruntHP: CGFloat = 70
    static let gruntSpeed: CGFloat = 70
    static let heavyHP: CGFloat = 150
    static let heavySpeed: CGFloat = 45
    static let fastHP: CGFloat = 40
    static let fastSpeed: CGFloat = 120
    static let mobCollisionRange: CGFloat = 22
    static let mobDamagePerSecond: CGFloat = 12
    static let mobGoldReward: Int = 5

    // Башня
    static let towerRange: CGFloat = 200
    static let towerFireRate: CGFloat = 1.0 // раз/сек
    static let towerDamage: CGFloat = 25
    static let towerCost = Cost(gold: 30, wood: 30, stone: 20)
    static let towerUpgradeCost = Cost(gold: 35, wood: 20, stone: 20)
    static let towerUpgradeMultiplier: CGFloat = 1.35

    // Шахтёр (пассивный добытчик)
    static let workerCostGold = 25
    static let workerTickSeconds: TimeInterval = 5
    static let workerYieldWood = 15
    static let workerYieldStone = 12

    // Экономика старта
    static let startGold = 50
    static let startWood = 40
    static let startStone = 30

    // Волны
    static let secondsBetweenWaves: TimeInterval = 18
    static let spawnInterval: TimeInterval = 1.2
    static let mobsPerWaveBase: Int = 6

    // Опыт
    static let xpPerWaveClear = 25
}
