//
//  CollaborativeSessions_ViewController.swift
//  ARKit-Invader
//
//  Created by drama on 2019/09/16.
//  Copyright © 2019 1901drama. All rights reserved.
//

// 作成中

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
    static let serviceType = "arkit3-sample"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.session.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isCollaborationEnabled = true
        sceneView.session.run(configuration)
        
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        initMultipeerSession(receivedDataHandler: receivedData)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: sceneView)
        
        let results = sceneView.hitTest(pos, types: .featurePoint)
        if !results.isEmpty {
            let hitTestResult = results.first!
            
            let anchor = ARAnchor(name: "ship", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            
            //let transform = hitTestResult.worldTransform
            //let thirdColumn = transform.columns.3

            //guard let scene = SCNScene(named: "ship.scn",inDirectory: "art.scnassets") else {fatalError()}
            //let shipNode = (scene.rootNode.childNode(withName: "ship", recursively: false))!
            //shipNode.position = SCNVector3( thirdColumn.x, thirdColumn.y, thirdColumn.z)
            //sceneView.scene.rootNode.addChildNode(shipNode)
        }
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "ship" {
            guard let scene = SCNScene(named: "ship.scn",inDirectory: "art.scnassets") else {fatalError()}
            let shipNode = (scene.rootNode.childNode(withName: "ship", recursively: false))!
            node.addChildNode(shipNode)
        }
    }
    
    
    func session(_ session: ARSession, didOutputCollaborationData data:ARSession.CollaborationData) {
        if let collaborationDataEncoded = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true){
            self.sendToAllPeers(collaborationDataEncoded)
            print("1*****",collaborationDataEncoded)
        }
    }

    func receivedData(_ data:Data, from peer: MCPeerID) {
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data){
            sceneView.session.update(with: collaborationData)
            print("2*****",collaborationData)
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("3*****",anchors.first as Any)
        if let anchor = anchors.first as? ARParticipantAnchor {
            print("4*****",anchor)
            let transform = anchor.transform
            let thirdColumn = transform.columns.3
/*
            guard let scene = SCNScene(named: "ship.scn",inDirectory: "art.scnassets") else {fatalError()}
            let shipNode = (scene.rootNode.childNode(withName: "ship", recursively: false))!
            shipNode.position = SCNVector3( thirdColumn.x, thirdColumn.y, thirdColumn.z)
            sceneView.scene.rootNode.addChildNode(shipNode)
 */
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let anchor = anchors.first as? ARParticipantAnchor {
            let transform = anchor.transform
        }
    }

 }


//MultipeerConnectivity
extension CollaborativeSessions_ViewController: MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate{
    
    func initMultipeerSession(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        //print("initMultipeerSession:",serviceAdvertiser,serviceBrowser)
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
         do { try mpsession.send(data, toPeers: mpsession.connectedPeers, with: .reliable) }
         catch { print("** error sending data to peers: \(error.localizedDescription)") }
     }
    
    var connectedPeers: [MCPeerID] { return mpsession.connectedPeers }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedData(data, from: peerID)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("state: \(state)")
        case .connected:
            print("state: \(state)")
            self.participantID = peerID
        case .connecting:
            print("state: \(state)")
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

