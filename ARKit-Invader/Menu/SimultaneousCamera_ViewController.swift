//
//  SimultaneousCamera_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SimultaneousCamera_ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var BackFaceNode = SCNNode()
    let device = MTLCreateSystemDefaultDevice()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        let configuration = ARWorldTrackingConfiguration()
        configuration.userFaceTrackingEnabled = true
        sceneView.session.run(configuration)
        
        //ARKit3の機能をわかりやすくする為に、BackCamera側に顔モデルを表示する処理を入れています。
        guard let scene = SCNScene(named: "face.scn",inDirectory: "art.scnassets") else {fatalError()}
        BackFaceNode = (scene.rootNode.childNode(withName: "ARFaceGeometry", recursively: false))!
        BackFaceNode.position = SCNVector3(0,0,-0.2)
        BackFaceNode.geometry = ARSCNFaceGeometry(device: device)!
        sceneView.scene.rootNode.addChildNode(BackFaceNode)
    }

    // MARK: - Delegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARFaceAnchor else { return }
        
        let FrontFaceNode = SCNNode()
        FrontFaceNode.geometry = ARSCNFaceGeometry(device: device)!
        node.addChildNode(FrontFaceNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        for Node in node.childNodes{
            guard let geometry = Node.geometry as? ARSCNFaceGeometry else { return }
            geometry.update(from: faceAnchor.geometry)
            BackFaceNode.geometry = geometry
        }
    }
    
}
