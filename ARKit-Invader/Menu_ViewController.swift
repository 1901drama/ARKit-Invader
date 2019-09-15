//
//  Menu_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/12.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Menu_ViewController: UIViewController {

    @IBOutlet weak var CoachingUI_Button: UIButton!
    @IBOutlet weak var PeopleOcclusion2D_Button: UIButton!
    @IBOutlet weak var PeopleOcclusion3D_Button: UIButton!
    @IBOutlet weak var MotionCapture2D_Button: UIButton!
    @IBOutlet weak var MotionCapture3D_Button: UIButton!
    @IBOutlet weak var MultipleFaceTracking_Button: UIButton!
    @IBOutlet weak var SimultaneousCamera_Button: UIButton!
    @IBOutlet weak var CollaborativeSessions_Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARBodyTrackingConfiguration.isSupported else {
            PeopleOcclusion2D_Button.isEnabled = false
            PeopleOcclusion3D_Button.isEnabled = false
            MotionCapture2D_Button.isEnabled = false
            MotionCapture3D_Button.isEnabled = false
            MultipleFaceTracking_Button.isEnabled = false
            SimultaneousCamera_Button.isEnabled = false
            return
        }
    }
    
    @IBAction func HowToUse_Touch(_ sender: Any) {
        let url = URL(string: "https://qiita.com/1901drama")
        UIApplication.shared.open(url!)
    }
    
}
