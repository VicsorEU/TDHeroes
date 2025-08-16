//
//  MainMenuScene.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import SpriteKit

final class MainMenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black

        let title = SKLabelNode(fontNamed: "Avenir-Heavy")
        title.text = "TD Heroes"
        title.fontSize = 44
        title.position = CGPoint(x: size.width/2, y: size.height/2 + 60)
        addChild(title)

        let play = SKLabelNode(fontNamed: "Avenir-Heavy")
        play.text = "Tap to Play (vs AI)"
        play.fontSize = 24
        play.position = CGPoint(x: size.width/2, y: size.height/2 - 10)
        play.name = "play"
        addChild(play)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let p = t.location(in: self)
        if atPoint(p).name == "play" {
            let gs = GameScene(size: size)
            gs.scaleMode = .resizeFill
            view?.presentScene(gs, transition: .doorsOpenVertical(withDuration: 0.5))
        }
    }
}
