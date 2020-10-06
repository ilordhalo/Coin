//
//  GameViewController.swift
//  Coin
//
//  Created by 张 家豪 on 2018/3/27.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {

    var audios = [String: SCNAudioSource]()
    var coin: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load audios
        
        let coinHard1 = SCNAudioSource.init(named: "audio/coin-hard1.m4a")!
        coinHard1.volume = 1.0
        coinHard1.isPositional = false
        coinHard1.load()
        audios["coin-hard1"] = coinHard1
        
        let coinMid1 = SCNAudioSource.init(named: "audio/coin-mid1.m4a")!
        coinHard1.volume = 1.0
        coinHard1.isPositional = false
        coinHard1.load()
        audios["coin-mid1"] = coinMid1
        
        let coinSeries1 = SCNAudioSource.init(named: "audio/coin-series1.m4a")!
        coinHard1.volume = 1.0
        coinHard1.isPositional = false
        coinHard1.load()
        audios["coin-series1"] = coinSeries1
        
        let coinSoft1 = SCNAudioSource.init(named: "audio/coin-soft1.m4a")!
        coinHard1.volume = 1.0
        coinHard1.isPositional = false
        coinHard1.load()
        audios["coin-soft1"] = coinSoft1
        
        let coinSoft2 = SCNAudioSource.init(named: "audio/coin-soft2.m4a")!
        coinHard1.volume = 1.0
        coinHard1.isPositional = false
        coinHard1.load()
        audios["coin-soft2"] = coinSoft2
        
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        scene.physicsWorld.contactDelegate = self
        
        
        coin = scene.rootNode.childNode(withName: "coin", recursively: true)!
        let pnode = scene.rootNode.childNode(withName: "pnode", recursively: true)!
        
        coin.physicsBody!.physicsShape = SCNPhysicsShape.init(node: pnode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.convexHull])
        //coin.physicsBody!.physicsShape
        /*
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        //scene.rootNode.addChildNode(cameraNode)
        coin.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 15)
 */
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        //scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.white
        //scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        /*
        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
         */
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.red
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        let scene = scnView.scene!
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        let coin = scene.rootNode.childNode(withName: "coin", recursively: true)!
        let physicsBody = coin.physicsBody!
        physicsBody.applyForce(SCNVector3(0, 6, 0), at: SCNVector3(5,5,0), asImpulse: true)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
        if contact.collisionImpulse > 0.2 {
            if contact.collisionImpulse > 0.6 {
                coin.runAction(SCNAction.playAudio(audios["coin-hard1"]!, waitForCompletion: true))
            }
            else if contact.collisionImpulse > 0.4 {
                coin.runAction(SCNAction.playAudio(audios["coin-mid1"]!, waitForCompletion: true))
            }
            else {
                coin.runAction(SCNAction.playAudio(audios["coin-soft1"]!, waitForCompletion: true))
            }
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
        if contact.collisionImpulse > 0.2 {
            if contact.collisionImpulse > 0.6 {
                coin.runAction(SCNAction.playAudio(audios["coin-hard1"]!, waitForCompletion: true))
            }
            else if contact.collisionImpulse > 0.4 {
                coin.runAction(SCNAction.playAudio(audios["coin-mid1"]!, waitForCompletion: true))
            }
            else {
                coin.runAction(SCNAction.playAudio(audios["coin-soft1"]!, waitForCompletion: true))
            }
        }
    }

}
