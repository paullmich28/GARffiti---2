//
//  ViewController.swift
//  GARffiti
//
//  Created by Paulus Michael on 15/05/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var exampleArray = [SCNNode]()
    @IBOutlet weak var colorWheel: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
//                print("Plane clicked.")
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.005))
                let sphereMaterial = SCNMaterial()
                sphereMaterial.diffuse.contents = colorWheel.selectedColor!
                
                sphereNode.geometry?.materials = [sphereMaterial]
                
                sphereNode.position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: hitResult.worldTransform.columns.3.y,
                    z: hitResult.worldTransform.columns.3.z
                )
                
                exampleArray.append(sphereNode)
                
                sceneView.scene.rootNode.addChildNode(sphereNode)
            }else{
//                print("Clicked something else.")
            }
            
        }
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
        }else{
            return
        }
    }
}
