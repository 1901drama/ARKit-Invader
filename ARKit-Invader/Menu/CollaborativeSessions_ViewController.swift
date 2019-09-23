//
//  CollaborativeSessions_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

class CollaborativeSessions_ViewController: UIViewController, ARSCNViewDelegate,ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var myPeerID:MCPeerID!
    var participantID: MCPeerID!
    private var mpsession: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrowser: MCNearbyServiceBrowser!
    static let serviceType = "arkit-invader"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        initMultipeerSession(receivedDataHandler: receivedData)
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isCollaborationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: sceneView)
        
        let results = sceneView.hitTest(pos, types: .featurePoint)
        if !results.isEmpty {
            let hitTestResult = results.first!
            let anchor = ARAnchor(name: "invader", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    // MARK: - Delegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "invader" {
            //自分が追加した場合は、invaderAで表示
            if anchor.sessionIdentifier == self.sceneView.session.identifier {
                guard let scene = SCNScene(named: "invaderA.scn",inDirectory: "art.scnassets") else { return }
                let sceneNode = (scene.rootNode.childNode(withName: "invaderA", recursively: false))!
                node.addChildNode(sceneNode)
                
            //相手が追加した場合は、invaderBで表示
            } else {
                guard let scene = SCNScene(named: "invaderB.scn",inDirectory: "art.scnassets") else { return }
                let sceneNode = (scene.rootNode.childNode(withName: "invaderB", recursively: false))!
                node.addChildNode(sceneNode)
            }
        }
        
        if anchor is ARParticipantAnchor {
            guard let scene = SCNScene(named: "invaderC.scn",inDirectory: "art.scnassets") else { return }
            let participantNode = (scene.rootNode.childNode(withName: "invaderC", recursively: false))!
            node.addChildNode(participantNode)
        }
    }
    
    func session(_ session: ARSession, didOutputCollaborationData data:ARSession.CollaborationData) {
        if let collaborationDataEncoded = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true){
            self.sendToAllPeers(collaborationDataEncoded)
        }
    }

    func receivedData(_ data:Data, from peer: MCPeerID) {
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data){
            self.sceneView.session.update(with: collaborationData)
        }
    }
    
}

// MARK: - MultipeerConnectivity

extension CollaborativeSessions_ViewController: MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate{
    
    func initMultipeerSession(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        mpsession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        mpsession.delegate = self
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: CollaborativeSessions_ViewController.serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: CollaborativeSessions_ViewController.serviceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    func sendToAllPeers(_ data: Data) {
         do {
            try mpsession.send(data, toPeers: mpsession.connectedPeers, with: .reliable)
         } catch {
            print("*** error sending data to peers: \(error.localizedDescription)")
        }
     }
    
    var connectedPeers: [MCPeerID] {
        return mpsession.connectedPeers
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedData(data, from: peerID)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("*** estate: \(state)")
        case .connected:
            print("*** estate: \(state)")
            self.participantID = peerID
        case .connecting:
            print("*** estate: \(state)")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        browser.invitePeer(peerID, to: mpsession, withContext: nil, timeout: 10)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.mpsession)
    }
    
}
