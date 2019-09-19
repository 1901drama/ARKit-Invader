//
//  MotionCapture3D_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Combine

class MotionCapture3D_ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!

    var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        arView.scene.addAnchor(characterAnchor)
        
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "art.scnassets/robot").sink(
            receiveCompletion: { completion in
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            }
        })
    }

    // MARK: - Delegate

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            let bodyPosition = simd_make_float3(
                bodyAnchor.transform.columns.3.x - 1,
                bodyAnchor.transform.columns.3.y,
                bodyAnchor.transform.columns.3.z
            )
            characterAnchor.position = bodyPosition
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
            if let character = character, character.parent == nil {
                characterAnchor.addChild(character)
            }
        }
    }
    
}
