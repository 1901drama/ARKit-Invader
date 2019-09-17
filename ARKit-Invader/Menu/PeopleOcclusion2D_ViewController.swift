//
//  PeopleOcclusion2D_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PeopleOcclusion2D_ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self        
        sceneView.scene = SCNScene(named: "art.scnassets/invaderA.scn")!

        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .personSegmentation
        sceneView.session.run(configuration)
    }
    
}
