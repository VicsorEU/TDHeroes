import SpriteKit

final class WaveManager {
    unowned let scene: GameScene
    private var spawnTimer: TimeInterval = 0
    private var spawnCount: Int = 0
    private(set) var waveActive = false   // <-- даём доступ только на чтение

    init(scene: GameScene) { self.scene = scene }

    func startNextWave() {
        // Не даём стартовать, если волна уже идёт
        guard waveActive == false else { return }
        waveActive = true
        spawnCount = GameConfig.mobsPerWaveBase + scene.state.waveIndex
        spawnTimer = 0
        scene.state.waveIndex += 1
    }

    func update(_ dt: TimeInterval) {
        guard waveActive else { return }
        spawnTimer += dt

        if spawnCount > 0 && spawnTimer >= GameConfig.spawnInterval {
            spawnTimer = 0
            spawnOne(for: .player)
            spawnOne(for: .enemy)
            spawnCount -= 1
        }

        // Снимок мобов (чтобы не итерироваться по scene.children напрямую)
        let anyMobsLeft = scene.snapshotMobs().isEmpty == false

        if spawnCount == 0 && anyMobsLeft == false {
            waveActive = false
            scene.state.addXP(GameConfig.xpPerWaveClear)
            scene.hud.updateResources(scene.state)
            scene.run(.sequence([
                .wait(forDuration: GameConfig.secondsBetweenWaves),
                .run { [weak self] in self?.startNextWave() }
            ]))
        }
    }

    private func spawnOne(for team: Team) {
        let types: [UnitType] = [.grunt, .fast, .heavy]
        let type = types.randomElement()!
        let mob = MobNode(type: type, team: team)

        let x = scene.size.width/2 + CGFloat.random(in: -80...80)
        let y: CGFloat = (team == .player) ? 120 : scene.size.height - 120
        mob.position = CGPoint(x: x, y: y)
        mob.targetCastle = (team == .player) ? scene.enemyCastle : scene.playerCastle
        scene.addChild(mob)
    }
}
