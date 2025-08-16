//
//  EconomyManager.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class EconomyManager {
    unowned let scene: GameScene
    private var workerTimer: TimeInterval = 0

    init(scene: GameScene) { self.scene = scene }

    func update(_ dt: TimeInterval) {
        workerTimer += dt
        if workerTimer >= GameConfig.workerTickSeconds {
            workerTimer = 0
            // Пассивный доход от рабочих
            let wWood  = scene.state.workersWood
            let wStone = scene.state.workersStone
            if wWood > 0 {
                scene.state.wood += GameConfig.workerYieldWood * wWood
            }
            if wStone > 0 {
                scene.state.stone += GameConfig.workerYieldStone * wStone
            }
            scene.hud.updateResources(scene.state)
        }
    }
}
