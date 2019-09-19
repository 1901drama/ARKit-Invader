//
//  MultipleFaceTracking_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MultipleFaceTracking_ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var FaceNodeIDs = [UUID]()
    let device = MTLCreateSystemDefaultDevice()!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
                
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 3
        sceneView.session.run(configuration)
    }
    
    // MARK: - Delegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        if FaceNodeIDs.firstIndex(of: faceAnchor.identifier) == nil {
            let maskGeometry = ARSCNFaceGeometry(device: device)!
            maskGeometry.firstMaterial?.lightingModel = .physicallyBased
            
            //ARKit3の機能をわかりやすくする為に、顔3つまで色分けする処理を入れています。
            FaceNodeIDs.append(faceAnchor.identifier)
            switch FaceNodeIDs.count % 3 {
                case 0:maskGeometry.firstMaterial?.diffuse.contents = UIColor.red
                case 1:maskGeometry.firstMaterial?.diffuse.contents = UIColor.yellow
                case 2:maskGeometry.firstMaterial?.diffuse.contents = UIColor.blue
                default:break
            }
            
            let FaceNode = SCNNode()
            FaceNode.geometry = maskGeometry
            node.addChildNode(FaceNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        if FaceNodeIDs.firstIndex(of: faceAnchor.identifier) != nil {
            for Node in node.childNodes{
                guard let geometry = Node.geometry as? ARSCNFaceGeometry else { return }
                geometry.update(from: faceAnchor.geometry)
            }
        }
    }
    
}
