//
//  HUDDelegate.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

protocol HUDDelegate: AnyObject {
    func didTapBuildTower()
    func didTapUpgradeSelectedTower()
    func didTapBuyWorkerWood()
    func didTapBuyWorkerStone()
    func didSelectHeroClass(_ cls: HeroClass)
}

final class HUDLayer: SKNode {

    weak var delegate: HUDDelegate?
    private var labels: [String: SKLabelNode] = [:]
    private var selectionFrame: SKShapeNode?

    override init() {
        super.init()
        isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) { fatalError() }

    // Создание панели UI
    func setup(in size: CGSize, state: GameState) {
        removeAllChildren()

        // Верхняя строка ресурсов
        let res = SKLabelNode(fontNamed: "Menlo-Bold")
        res.fontSize = 14
        res.horizontalAlignmentMode = .left
        res.position = CGPoint(x: 12, y: size.height - 24)
        res.text = "Gold \(state.gold)  Wood \(state.wood)  Stone \(state.stone)  XP \(state.xp)"
        addChild(res)
        labels["res"] = res

        // Кнопки: башня, апгрейд, воркеры
        func makeButton(_ title: String, pos: CGPoint) -> SKLabelNode {
            let l = SKLabelNode(fontNamed: "Menlo-Bold")
            l.fontSize = 14
            l.text = "[ \(title) ]"
            l.position = pos
            l.name = "btn:\(title)"
            return l
        }
        let y: CGFloat = 24
        addChild(makeButton("Build Tower", pos: CGPoint(x: 90, y: y)))
        addChild(makeButton("Upgrade Tower", pos: CGPoint(x: 230, y: y)))
        addChild(makeButton("+Worker Wood", pos: CGPoint(x: 380, y: y)))
        addChild(makeButton("+Worker Stone", pos: CGPoint(x: 540, y: y)))

        // Выбор класса героя (один раз на старте)
        let classes = HeroClass.allCases
        for (i, c) in classes.enumerated() {
            let b = makeButton(c.rawValue, pos: CGPoint(x: size.width - 80 - CGFloat(i)*90, y: size.height - 24))
            b.name = "hero:\(c.rawValue)"
            addChild(b)
        }

        // Рамка выделения
        selectionFrame = SKShapeNode(rectOf: CGSize(width: 48, height: 48))
        selectionFrame?.strokeColor = .yellow
        selectionFrame?.lineWidth = 3
        selectionFrame?.isHidden = true
        addChild(selectionFrame!)
    }

    func updateResources(_ state: GameState) {
        labels["res"]?.text = "Gold \(state.gold)  Wood \(state.wood)  Stone \(state.stone)  XP \(state.xp)"
    }

    func showSelection(at pos: CGPoint?) {
        selectionFrame?.isHidden = (pos == nil)
        if let p = pos { selectionFrame?.position = p }
    }

    // Обработка нажатий по кнопкам HUD
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let loc = t.location(in: self)
        if let node = atPoint(loc) as? SKLabelNode, let name = node.name {
            if name == "btn:Build Tower" { delegate?.didTapBuildTower() }
            else if name == "btn:Upgrade Tower" { delegate?.didTapUpgradeSelectedTower() }
            else if name == "btn:+Worker Wood" { delegate?.didTapBuyWorkerWood() }
            else if name == "btn:+Worker Stone" { delegate?.didTapBuyWorkerStone() }
            else if name.hasPrefix("hero:") {
                let raw = name.replacingOccurrences(of: "hero:", with: "")
                if let cls = HeroClass(rawValue: raw) { delegate?.didSelectHeroClass(cls) }
            }
        }
    }
}
