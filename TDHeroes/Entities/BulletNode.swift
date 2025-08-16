import SpriteKit

final class BulletNode: SKShapeNode {
    var damage: CGFloat = 0
    var ownerTeam: Team = .player
    var velocity: CGVector = .zero
    var lifetime: TimeInterval = 3

    init(radius: CGFloat, damage: CGFloat, team: Team, velocity: CGVector) {
        super.init()
        let circle = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)
        path = circle
        fillColor = .white
        strokeColor = .clear
        self.damage = damage
        self.ownerTeam = team
        self.velocity = velocity

        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.categoryBitMask = PhysicsCategory.bullet
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.mob | PhysicsCategory.hero | PhysicsCategory.castle
    }

    required init?(coder: NSCoder) { fatalError() }

    func tick(_ dt: CGFloat) {
        // Если узел уже снят со сцены — выходим
        guard parent != nil else { return }
        position.x += velocity.dx * dt
        position.y += velocity.dy * dt
        lifetime -= TimeInterval(dt)
        if lifetime <= 0 {
            // Удаляем “мягко” в следующем цикле, чтобы не мутировать дерево при обходе
            run(.removeFromParent())
        }
    }
}
