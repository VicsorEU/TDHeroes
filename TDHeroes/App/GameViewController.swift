import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false
        view = skView

        let scene = MainMenuScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool { true }
}
