import UIKit
import SceneKit
import ARKit
import ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var qMarkNode: SCNReferenceNode?
    private var boxNode: SCNNode?
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        
        
        /*
         LIGHTS START
         */
        // Create and add an ambient light to the scene
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        // Create and add a directional light to the scene
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000
        directionalLight.castsShadow = true
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.position = SCNVector3(0, 10, 10) // Adjust the position as needed
        scene.rootNode.addChildNode(directionalLightNode)
        /*
         LIGHTS END
         */
        
        
        /*
         3D OBJECTS START
         */
        // Load the qMark USDZ model
        guard let qMarkUrl = Bundle.main.url(forResource: "qMark", withExtension: "usdz") else {
            fatalError("Failed to find qMark.usdz in the bundle.")
        }
        qMarkNode = SCNReferenceNode(url: qMarkUrl)
        qMarkNode?.load()

        // Position the qMark node next to the box
        qMarkNode?.position = SCNVector3(0, -1, -1)
        qMarkNode?.scale = SCNVector3(0.001, 0.001, 0.001)
        qMarkNode?.name = "qMarkNode"
        
        scene.rootNode.addChildNode(qMarkNode!)
        /*
         3D OBJECTS END
         */
        
        /*
         IMAGES START
         */
        /*
         IMAGES END
         */
        // Add tap gesture recognizer to the sceneView
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(objectTapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer2)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    @objc func objectTapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, options: nil)
        let hitNode = hitTestResults.first?.node
        // Necessary to see the names.
        if let hitNodeName = hitNode?.name {
            print("\(hitNodeName) Tapped")
        }
        if let hitNodeName = hitNode?.name, hitNodeName == "Box005_02___Default_0" {
            // Remove the qMarkNode from the parent node
            qMarkNode?.removeFromParentNode()
            // Now that the box is removed, show the image
            let image = UIImage(named: "tree.png")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.contentMode = .scaleAspectFit

            // Create a plane with the same dimensions as the image view
            let imagePlane = SCNPlane(width: 0.2, height: 0.2)
            imagePlane.firstMaterial?.diffuse.contents = imageView

            // Create a node with the image plane and position it
            let imageNode = SCNNode(geometry: imagePlane)
            imageNode.position = SCNVector3(x: 0, y: -1, z: -1)

            // Add the image node to the scene
            sceneView.scene.rootNode.addChildNode(imageNode)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
}








//        // Create a box geometry
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//
//        // Create a material for the box
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.blue
//        box.materials = [material]
//
//        // Create a node with the box geometry
//        let boxNode = SCNNode(geometry: box)
//        boxNode.position = SCNVector3(0, 0, -1)
//        boxNode.name = "boxNode"
//
//        // Add the box node to the scene
//        sceneView.scene.rootNode.addChildNode(boxNode)

//    @objc func boxTapped(sender: UITapGestureRecognizer) {
//        let tapLocation = sender.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(tapLocation, options: nil)
//        let hitNode = hitTestResults.first?.node
//
//        if let hitNodeName = hitNode?.name, hitNodeName == "boxNode" {
//            print("Box Tapped")
//        }
//
//    }




//import UIKit
//import SceneKit
//import ARKit
//import Vision
//import SceneKit.ModelIO
//
//class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
//
//    @IBOutlet var sceneView: ARSCNView!
//    private var imageView: UIImageView!
//    // private var imageNode: SCNNode?
//    private var qMarkNode: SCNNode?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Enable user interaction on the entire sceneView
//        sceneView.isUserInteractionEnabled = true
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene()
//
//        // Set the scene to the view
//        sceneView.scene = scene
//
//        /*
//         MODELS
//         */
//
//        // Load the qMark USDZ model
//        guard let qMarkUrl = Bundle.main.url(forResource: "qMark", withExtension: "usdz") else {
//            fatalError("Failed to find qMark.usdz in the bundle.")
//        }
//        let qMarkMdlAsset = MDLAsset(url: qMarkUrl)
//        let qMarkObjectScene = SCNScene(mdlAsset: qMarkMdlAsset)
//
//        // Create a node from the loaded qMark USDZ model
//        qMarkNode = SCNNode()
//        for child in qMarkObjectScene.rootNode.childNodes {
//            qMarkNode?.addChildNode(child)
//        }
//
//        // Set the position and scale of the qMark object node
//        qMarkNode?.position = SCNVector3(x: 0, y: -1, z: -1)
//        let qMarkScale: Float = 0.001
//        qMarkNode?.scale = SCNVector3(qMarkScale, qMarkScale, qMarkScale)
//
//        // Set the name of the qMark node for identification
//        qMarkNode?.name = "qMarkNode"
//
//        // Add the qMark object node to the scene
//        sceneView.scene.rootNode.addChildNode(qMarkNode!)
//
//        // Enable user interaction on the qMark object
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(qMarkTapped))
//        sceneView.addGestureRecognizer(tapGestureRecognizer)
//
//    }
//
//    @objc func qMarkTapped(sender: UITapGestureRecognizer) {
//        let tapLocation = sender.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(tapLocation, options: nil)
//
//        if let hitNode = hitTestResults.first?.node, hitNode.name == "qMarkNode" {
//            print("Tapped.")
//
//            // Open a URL when qMarkNode is tapped
//            if let url = URL(string: "https://www.google.com") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//
//            // Remove the qMarkNode from the scene
//            hitNode.removeFromParentNode()
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Create a transform with a translation of 0.2 meters in front of the camera.
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -0.2
//
//        if let currentFrame = sceneView.session.currentFrame {
//            let transform = simd_mul(currentFrame.camera.transform, translation)
//
//            // Add a new anchor to the session.
//            let anchor = ARAnchor(transform: transform)
//            sceneView.session.add(anchor: anchor)
//        }
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView.session.pause()
//    }
//}


// Load the first USDZ model
//        guard let firstUrl = Bundle.main.url(forResource: "high_poly_question_mark", withExtension: "usdz") else {
//            fatalError("Failed to find high_poly_question_mark.usdz in the bundle.")
//        }
//        let firstMdlAsset = MDLAsset(url: firstUrl)
//        let firstObjectScene = SCNScene(mdlAsset: firstMdlAsset)
//
//        // Create a node from the loaded first USDZ model
//        let firstObjectNode = SCNNode()
//        for child in firstObjectScene.rootNode.childNodes {
//            firstObjectNode.addChildNode(child)
//        }
//
//        // Set the position and scale of the first object node
//        firstObjectNode.position = SCNVector3(x: -0.5, y: -1, z: -1)
//        let firstScale: Float = 0.001
//        firstObjectNode.scale = SCNVector3(firstScale, firstScale, firstScale)
//
//        // Add the first object node to the scene
//        sceneView.scene.rootNode.addChildNode(firstObjectNode)

//    @objc func imageTapped() {
//        // Handle the tap on the image view
//        if let url = URL(string: "https://petras-iot.org/project/iot-of-trees-iotot/") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//        // Add the image node to the scene
//        sceneView.scene.rootNode.addChildNode(imageNode)
//        sceneView.scene.rootNode.addChildNode(imageNode_2)

//        // Add the dashes image node to the scene
//        sceneView.scene.rootNode.addChildNode(dashesImageNode)
        
        // Enable user interaction on the image view
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGestureRecognizer)

// Create and configure the image view
//        let image = UIImage(named: "tree.png")
//        imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        imageView.contentMode = .scaleAspectFit

//        /*
//         IMAGES
//         */
//
//        // Create a plane with the same dimensions as the image view
//        let imagePlane = SCNPlane(width: 0.2, height: 0.2)
//        imagePlane.firstMaterial?.diffuse.contents = imageView
//
//        // Create a node with the image plane and position it
//        let imageNode = SCNNode(geometry: imagePlane)
//        imageNode.position = SCNVector3(x: 0, y: -0.5, z: -0.5)
//
//        // Create a node with the image plane and position it
//        let imageNode_2 = SCNNode(geometry: imagePlane)
//        imageNode_2.position = SCNVector3(x: 0, y: -0.5, z: -0.6)
//
//
//        // Create and configure the dashes image view
//        let dashesImage = UIImage(named: "dashes.png")
//        let dashesImageView = UIImageView(image: dashesImage)
//        dashesImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        dashesImageView.contentMode = .scaleAspectFit
//
//        // Create a plane with the same dimensions as the dashes image view
//        let dashesImagePlane = SCNPlane(width: 0.2, height: 0.2)
//        dashesImagePlane.firstMaterial?.diffuse.contents = dashesImageView
//
//        // Create a node with the dashes image plane and position it
//        let dashesImageNode = SCNNode(geometry: dashesImagePlane)
//        dashesImageNode.position = SCNVector3(x: 0, y: -0.7, z: -0.5)
//    @objc func imageTapped() {
//        // Handle the tap on the image view
//        if let imageNode = self.imageNode {
//            if imageNode.parent == nil {
//                sceneView.scene.rootNode.addChildNode(imageNode)
//            } else {
//                imageNode.removeFromParentNode()
//            }
//        }
//    }
