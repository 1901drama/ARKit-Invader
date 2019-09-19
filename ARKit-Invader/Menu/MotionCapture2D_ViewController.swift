//
//  MotionCapture2D_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import Combine

class MotionCapture2D_ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
    let circleWidth: CGFloat = 10
    let circleHeight: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.session.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .bodyDetection
        arView.session.run(configuration)
    }

    // MARK: - Delegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        ClearCircleLayers()

        if let detectedBody = frame.detectedBody {
            guard let interfaceOrientation = arView.window?.windowScene?.interfaceOrientation else { return }
            let transform = frame.displayTransform(for: interfaceOrientation, viewportSize: arView.frame.size)

            detectedBody.skeleton.jointLandmarks.forEach { landmark in
                let normalizedCenter = CGPoint(x: CGFloat(landmark[0]), y: CGFloat(landmark[1])).applying(transform)
                let center = normalizedCenter.applying(CGAffineTransform.identity.scaledBy(x: arView.frame.width, y: arView.frame.height))
                let rect = CGRect(origin: CGPoint(x: center.x - circleWidth/2, y: center.y - circleHeight/2), size: CGSize(width: circleWidth, height: circleHeight))
                let circleLayer = CAShapeLayer()
                circleLayer.path = UIBezierPath(ovalIn: rect).cgPath

                arView.layer.addSublayer(circleLayer)
            }
        }
    }

    private func ClearCircleLayers() {
        arView.layer.sublayers?.compactMap { $0 as? CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
    }
    
}
