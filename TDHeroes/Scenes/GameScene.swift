import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {

    // Состояние + HUD
    let state = GameState()
    let hud = HUDLayer()

    // Объекты
    var playerCastle: CastleNode!
    var enemyCastle: CastleNode!
    var playerHero: HeroNode!
    var selectedTower: TowerNode?

    // Визуальные ресурсы
    var woodNode: ResourceNode!
    var stoneNode: ResourceNode!

    // Менеджеры
    var waveManager: WaveManager?
    var economyManager: EconomyManager!
    var ai: AIController!

    // Прочее
    private var lastUpdateTime: TimeInterval = 0
    var enemyBudgetGold: Int = 50
    private var buildModeRequested = false

    // === Новое: очередь попаданий из физики, чтобы не мутировать сцену в колбэке ===
    private var hitQueue: [(bullet: BulletNode, target: SKNode)] = []

    // Удобные снимки
    func snapshotMobs() -> [MobNode]       { children.compactMap { $0 as? MobNode } }
    func snapshotTowers() -> [TowerNode]   { children.compactMap { $0 as? TowerNode } }
    func snapshotBullets() -> [BulletNode] { children.compactMap { $0 as? BulletNode } }

    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        backgroundColor = .systemGreen
        physicsWorld.contactDelegate = self

        buildMap()
        setupHUD()
        setupManagers()

        spawnHero(.archer)

        run(.sequence([.wait(forDuration: 2), .run { [weak self] in
            self?.waveManager?.startNextWave()
        }]))
    }

    private func buildMap() {
        let divider = SKShapeNode(rectOf: CGSize(width: size.width - 8, height: GameConfig.halfDividerHeight))
        divider.fillColor = .white.withAlphaComponent(0.9)
        divider.strokeColor = .clear
        divider.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(divider)

        playerCastle = CastleNode(size: CGSize(width: 120, height: 30), team: .player)
        playerCastle.position = CGPoint(x: size.width/2 - 60, y: 40)
        addChild(playerCastle)

        enemyCastle = CastleNode(size: CGSize(width: 120, height: 30), team: .enemy)
        enemyCastle.position = CGPoint(x: size.width/2 - 60, y: size.height - 70)
        addChild(enemyCastle)

        woodNode = ResourceNode(type: .wood, size: CGSize(width: 110, height: 180))
        woodNode.position = CGPoint(x: 12, y: size.height - 210)
        addChild(woodNode)

        stoneNode = ResourceNode(type: .stone, size: CGSize(width: 110, height: 180))
        stoneNode.position = CGPoint(x: size.width - 122, y: 30)
        addChild(stoneNode)
    }

    private func setupHUD() {
        hud.setup(in: size, state: state)
        hud.zPosition = 1000
        hud.delegate = self
        addChild(hud)
    }

    private func setupManagers() {
        waveManager = WaveManager(scene: self)
        economyManager = EconomyManager(scene: self)
        ai = AIController(scene: self)
    }

    // MARK: - Спавн и постройка
    func spawnHero(_ cls: HeroClass) {
        playerHero?.removeFromParent()
        playerHero = HeroNode(heroClass: cls)
        playerHero.team = .player
        playerHero.position = CGPoint(x: size.width/2, y: 110)
        addChild(playerHero)
    }

    func placeTower(at pos: CGPoint, team: Team) {
        let valid = (team == .player) ? (pos.y < size.height/2 - 10) : (pos.y > size.height/2 + 10)
        guard valid else { return }
        let t = TowerNode(size: CGSize(width: 30, height: 30), team: team)
        t.position = CGPoint(x: pos.x - 15, y: pos.y - 15)
        addChild(t)
    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        let dt = (lastUpdateTime == 0) ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        let dtf = CGFloat(dt)

        // 1) Безопасно обрабатываем попадания, накопленные в физическом колбэке
        if hitQueue.isEmpty == false {
            let events = hitQueue
            hitQueue.removeAll(keepingCapacity: true)
            for (bullet, target) in events {
                // Узлы могли исчезнуть к моменту обработки
                guard bullet.parent != nil else { continue }

                if let mob = target as? MobNode, mob.team != bullet.ownerTeam {
                    mob.applyDamage(bullet.damage)
                    bullet.removeFromParent()
                    if mob.isDead() {
                        if bullet.ownerTeam == .player { state.addGold(GameConfig.mobGoldReward) }
                        mob.removeFromParent()
                        hud.updateResources(state)
                    }
                } else if let castle = target as? CastleNode {
                    castle.applyDamage(bullet.damage)
                    bullet.removeFromParent()
                }
            }
        }

        // 2) Тикаем пули (работаем по снимку)
        for b in snapshotBullets() { b.tick(dtf) }

        // 3) Логика менеджеров
        waveManager?.update(dt)
        economyManager.update(dt)
        ai.update(dt)

        // 4) Огонь башен и героя
        let enemies = snapshotMobs().filter { $0.team == .enemy }
        autoFireTowers(dt, towers: snapshotTowers(), enemies: enemies)

        // 5) Движение мобов
        moveMobs(dtf, mobs: snapshotMobs())

        // 6) Проверка конца игры
        checkGameOver()
    }

    private func moveMobs(_ dt: CGFloat, mobs: [MobNode]) {
        for mob in mobs where mob.isDead() == false {
            guard let castle = mob.targetCastle else { continue }
            let dir = CGVector(dx: castle.position.x + 60 - mob.position.x,
                               dy: castle.position.y + 15 - mob.position.y)
            let len = sqrt(dir.dx*dir.dx + dir.dy*dir.dy)
            if len > GameConfig.mobCollisionRange {
                let vx = dir.dx / len * mob.moveSpeed
                let vy = dir.dy / len * mob.moveSpeed
                mob.position.x += vx * dt
                mob.position.y += vy * dt
            } else {
                let now = lastUpdateTime
                if now - mob.lastAttackTime > 0.5 {
                    mob.lastAttackTime = now
                    castle.applyDamage(mob.dps * 0.5)
                }
            }
        }
    }

    private func autoFireTowers(_ dt: TimeInterval, towers: [TowerNode], enemies: [MobNode]) {
        let now = lastUpdateTime

        for t in towers {
            if now - t.lastShotTime < TimeInterval(1.0 / Double(t.fireRate)) { continue }
            guard let target = enemies.min(by: { $0.position.distance(to: t.position) < $1.position.distance(to: t.position) }) else { continue }
            if t.position.distance(to: target.position) <= t.range {
                t.lastShotTime = now
                fire(from: t.position + CGPoint(x: 15, y: 15), to: target.position, damage: t.damageNow(), team: t.ownerTeam)
            }
        }

        if let hero = playerHero {
            if let target = enemies.min(by: { $0.position.distance(to: hero.position) < $1.position.distance(to: hero.position) }) {
                let dist = hero.position.distance(to: target.position)
                if hero.heroClass == .warrior {
                    if dist < 40, now - hero.lastShotTime > 0.35 {
                        hero.lastShotTime = now
                        target.applyDamage(hero.dps * 0.35)
                    } else if dist >= 40 {
                        moveNode(hero, toward: target.position, speed: hero.moveSpeed)
                    }
                } else {
                    if dist <= hero.range, now - hero.lastShotTime > 1.0 {
                        hero.lastShotTime = now
                        fire(from: hero.position, to: target.position, damage: hero.dps, team: .player, isAOE: hero.heroClass == .mage)
                    }
                }
            }
        }
    }

    private func fire(from: CGPoint, to: CGPoint, damage: CGFloat, team: Team, isAOE: Bool = false) {
        let dir = CGVector(dx: to.x - from.x, dy: to.y - from.y)
        let len = max(1, sqrt(dir.dx*dir.dx + dir.dy*dir.dy))
        let v = CGVector(dx: dir.dx/len * 420, dy: dir.dy/len * 420)
        let b = BulletNode(radius: 3, damage: damage, team: team, velocity: v)
        b.position = from
        addChild(b)

        if isAOE {
            b.lifetime = 0.6
            b.run(.sequence([
                .wait(forDuration: 0.6),
                .run { [weak self, weak b] in
                    guard let self, let b else { return }
                    let r: CGFloat = 60
                    let victims = self.snapshotMobs().filter { $0.team != team && $0.position.distance(to: b.position) <= r }
                    for v in victims { v.applyDamage(damage * 0.8) }
                    b.removeFromParent()
                }
            ]))
        }
    }

    private func checkGameOver() {
        if playerCastle.isDestroyed() || enemyCastle.isDestroyed() {
            let msg = SKLabelNode(fontNamed: "Avenir-Heavy")
            msg.fontSize = 36
            msg.text = playerCastle.isDestroyed() ? "Defeat" : "Victory!"
            msg.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(msg)
            isPaused = true
        }
    }

    // MARK: - Touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let p = t.location(in: self)

        if let tower = nodes(at: p).first(where: { $0 is TowerNode }) as? TowerNode {
            selectedTower = tower
            hud.showSelection(at: tower.position + CGPoint(x: 15, y: 15))
            return
        }

        if buildModeRequested {
            if state.canAfford(GameConfig.towerCost) && p.y < size.height/2 - 10 {
                state.pay(GameConfig.towerCost)
                placeTower(at: p, team: .player)
                hud.updateResources(state)
            }
            buildModeRequested = false
            return
        }

        moveNode(playerHero, toward: p, speed: playerHero.moveSpeed)
    }

    private func moveNode(_ node: SKNode?, toward target: CGPoint, speed: CGFloat) {
        guard let node = node else { return }
        node.removeAction(forKey: "move")
        let dist = node.position.distance(to: target)
        let time = dist / speed
        node.run(.move(to: target, duration: time), withKey: "move")
    }

    // MARK: - Physics
    func didBegin(_ contact: SKPhysicsContact) {
        // Складываем событие в очередь и выходим — никаких удалений/урона здесь!
        guard let a = contact.bodyA.node, let b = contact.bodyB.node else { return }
        if let bullet = a as? BulletNode {
            hitQueue.append((bullet, b))
        } else if let bullet = b as? BulletNode {
            hitQueue.append((bullet, a))
        }
    }
}

// MARK: - CGPoint helpers
private extension CGPoint {
    func distance(to p: CGPoint) -> CGFloat {
        sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: - HUDDelegate
extension GameScene: HUDDelegate {
    func didSelectHeroClass(_ cls: HeroClass) { spawnHero(cls) }
    func didTapBuildTower() { buildModeRequested = true }
    func didTapUpgradeSelectedTower() {
        guard let t = selectedTower else { return }
        let cost = GameConfig.towerUpgradeCost
        if state.canAfford(cost) { state.pay(cost); t.upgrade(); hud.updateResources(state) }
    }
    func didTapBuyWorkerWood() {
        if state.gold >= GameConfig.workerCostGold {
            state.gold -= GameConfig.workerCostGold
            state.workersWood += 1
            hud.updateResources(state)
        }
    }
    func didTapBuyWorkerStone() {
        if state.gold >= GameConfig.workerCostGold {
            state.gold -= GameConfig.workerCostGold
            state.workersStone += 1
            hud.updateResources(state)
        }
    }
}
