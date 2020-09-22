import Foundation
import SpriteKit
import PlaygroundSupport

public enum SecurityState {
    case open
    case closed
    case removed
}

public func runOSScene() {
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 840))
    if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}

public func runAppsScene() {
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 840))
    if let scene = AppsScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}

public func runFirewallScene() {
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 840))
    if let scene = FirewallScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}

