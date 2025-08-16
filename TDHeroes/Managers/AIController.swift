import SpriteKit

final class AIController {
    unowned let scene: GameScene
    private var decisionTimer: TimeInterval = 0

    init(scene: GameScene) { self.scene = scene }

    func update(_ dt: TimeInterval) {
        decisionTimer += dt
        guard decisionTimer >= 2.5 else { return }
        decisionTimer = 0

        // Не стартуем новую волну поверх активной
        if Int.random(in: 0...1) == 0 {
            if scene.waveManager?.waveActive == false {
                scene.waveManager?.startNextWave()
            }
            return
        }

        // Пробуем поставить башню у врага (верхняя половина), если хватает "бюджета"
        let cost = GameConfig.towerCost
        if scene.enemyBudgetGold >= cost.gold {
            scene.enemyBudgetGold -= cost.gold
            let w = CGFloat.random(in: 40...(scene.size.width - 40))
            let y = CGFloat.random(in: scene.size.height/2 + 60 ... scene.size.height - 160)
            scene.placeTower(at: CGPoint(x: w, y: y), team: .enemy)
        } else {
            scene.enemyBudgetGold += 4 // копим
        }
    }
}
