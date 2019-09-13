//
//  Menu_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/12.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit

class Menu_ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func HowToUse_Touch(_ sender: Any) {
        let url = URL(string: "https://qiita.com/1901drama")
        UIApplication.shared.open(url!)
    }
    
}
