//
//  GameState.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import Foundation

final class GameState {
    // Ресурсы игрока
    var gold: Int = GameConfig.startGold
    var wood: Int = GameConfig.startWood
    var stone: Int = GameConfig.startStone
    var xp: Int = 0

    // Рабочие (шахтёры) — пассивная добыча
    var workersWood: Int = 0
    var workersStone: Int = 0

    // Номер волны
    var waveIndex: Int = 0

    func canAfford(_ cost: Cost) -> Bool {
        gold >= cost.gold && wood >= cost.wood && stone >= cost.stone
    }
    func pay(_ cost: Cost) {
        gold -= cost.gold
        wood -= cost.wood
        stone -= cost.stone
    }
    func addGold(_ delta: Int) { gold += delta }
    func addXP(_ delta: Int) { xp += delta }
}
