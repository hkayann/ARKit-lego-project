import UIKit
import SceneKit
import ARKit
import ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private var yellowBoxNode: SCNReferenceNode?
    private var purpleBoxNode: SCNReferenceNode?
    private var greenBoxNode: SCNReferenceNode?
    private var pinkBoxNode: SCNReferenceNode?
    private var orangeBoxNode: SCNReferenceNode?
    private var blueBoxNode: SCNReferenceNode?
    private var boxNode: SCNNode?
    private var imageView: UIImageView!
    
    // Create a dictionary to track anchors by their identifiers (UUIDs)
    var trackedAnchors: [UUID: ARAnchor] = [:]
    
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
        let blueBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0, 0, -2, 1)])
        let blueAnchor = ARAnchor(name: "blueAnchor", transform: blueBoxAnchorTransform)
        let greenBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, 0, -2, 1)])
        let greenAnchor = ARAnchor(name: "greenAnchor", transform: greenBoxAnchorTransform)
        let resbeAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, 0.5, -2, 1)])
        let resbeAnchor = ARAnchor(name: "resbeAnchor", transform: resbeAnchorTransform)
        let pinkBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(-0.5, 0, -2, 1)])
        let pinkAnchor = ARAnchor(name: "pinkAnchor", transform: pinkBoxAnchorTransform)
        let orangeBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0, 0, -3, 1)])
        let orangeAnchor = ARAnchor(name: "orangeAnchor", transform: orangeBoxAnchorTransform)
        let purpleBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, 0, -3, 1)])
        let purpleAnchor = ARAnchor(name: "purpleAnchor", transform: purpleBoxAnchorTransform)
        let yellowBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(-0.5, 0, -3, 1)])
        let yellowAnchor = ARAnchor(name: "yellowAnchor", transform: yellowBoxAnchorTransform)

        // Add the anchor to the AR session
        sceneView.session.add(anchor: blueAnchor)
        sceneView.session.add(anchor: greenAnchor)
        sceneView.session.add(anchor: pinkAnchor)
        sceneView.session.add(anchor: orangeAnchor)
        sceneView.session.add(anchor: purpleAnchor)
        sceneView.session.add(anchor: yellowAnchor)
        sceneView.session.add(anchor: resbeAnchor)

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
//            qMarkNode?.removeFromParentNode()
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Anchor added to the scene.")
        print(anchor.name)
        let rotationAngle = Float.pi / 2.0 // 90 degrees in radians
        // Check if the anchor is the blueAnchor
        if anchor.name == "blueAnchor" {
            if let blueBoxUrl = Bundle.main.url(forResource: "blueBoxText", withExtension: "usdz"),
               let blueBoxNode = SCNReferenceNode(url: blueBoxUrl) {
                // Load, rotate, scale.
                blueBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                blueBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                blueBoxNode.load()

                // Add the blue box node as a child of the anchor's node
                node.addChildNode(blueBoxNode)
                // Create a floating animation
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.5)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                blueBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find blueBoxText.usdz in the bundle.")
            }
        }
        if anchor.name == "orangeAnchor" {
            if let orangeBoxUrl = Bundle.main.url(forResource: "orangeBoxText", withExtension: "usdz"),
               let orangeBoxNode = SCNReferenceNode(url: orangeBoxUrl) {
                // Load, rotate, scale.
                orangeBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                orangeBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                orangeBoxNode.load()

                // Add the blue box node as a child of the anchor's node
                node.addChildNode(orangeBoxNode)
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.4)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                orangeBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find orangeBoxText.usdz in the bundle.")
            }
        }
        if anchor.name == "purpleAnchor" {
            if let purpleBoxUrl = Bundle.main.url(forResource: "purpleBoxText", withExtension: "usdz"),
               let purpleBoxNode = SCNReferenceNode(url: purpleBoxUrl) {
                // Load, rotate, scale.
                purpleBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                purpleBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                purpleBoxNode.load()
                // Add the blue box node as a child of the anchor's node
                node.addChildNode(purpleBoxNode)
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.3)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                purpleBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find purpleBoxText.usdz in the bundle.")
            }
        }
        if anchor.name == "yellowAnchor" {
            if let yellowBoxUrl = Bundle.main.url(forResource: "yellowBoxText", withExtension: "usdz"),
               let yellowBoxNode = SCNReferenceNode(url: yellowBoxUrl) {
                // Load, rotate, scale.
                yellowBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                yellowBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                yellowBoxNode.load()

                // Add the blue box node as a child of the anchor's node
                node.addChildNode(yellowBoxNode)
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.2)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                yellowBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find yellowBoxText.usdz in the bundle.")
            }
        }
        if anchor.name == "greenAnchor" {
            if let greenBoxUrl = Bundle.main.url(forResource: "greenBoxText", withExtension: "usdz"),
               let greenBoxNode = SCNReferenceNode(url: greenBoxUrl) {
                // Load, rotate, scale.
                greenBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                greenBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                greenBoxNode.load()

                // Add the blue box node as a child of the anchor's node
                node.addChildNode(greenBoxNode)
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.1)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                greenBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find greenBoxText.usdz in the bundle.")
            }
        }
        if anchor.name == "pinkAnchor" {
            if let pinkBoxUrl = Bundle.main.url(forResource: "pinkBoxText", withExtension: "usdz"),
               let pinkBoxNode = SCNReferenceNode(url: pinkBoxUrl) {
                // Load, rotate, scale.
                pinkBoxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
                pinkBoxNode.scale = SCNVector3(0.001, 0.001, 0.001)
                pinkBoxNode.load()

                // Add the blue box node as a child of the anchor's node
                node.addChildNode(pinkBoxNode)
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.0)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                // Apply the floating animation to the blue box
                pinkBoxNode.runAction(floatActionLoop)
            } else {
                fatalError("Failed to find pinkBoxText.usdz in the bundle.")
            }
        }
        // Check if the anchor is the resbeAnchor
        if anchor.name == "resbeAnchor" {
            print("here")
            // Load the image
            if let resbeImage = UIImage(named: "resbe.png") {
                print("there")
                // Perform UI operations on the main thread
                DispatchQueue.main.async {
                    // Create an image view to display the image
                    let imageView = UIImageView(image: resbeImage)
                    imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                    imageView.contentMode = .scaleAspectFit

                    // Create a plane with the same dimensions as the image view
                    let imagePlane = SCNPlane(width: 0.5, height: 0.5)
                    imagePlane.firstMaterial?.diffuse.contents = imageView

                    // Create a node with the image plane and adjust its position
                    let resbeNode = SCNNode(geometry: imagePlane)
                    node.addChildNode(resbeNode)
                    let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 1.1)
                    floatUpAction.timingMode = .easeInEaseOut
                    let floatDownAction = floatUpAction.reversed()
                    let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                    let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                    // Apply the floating animation to the blue box
                    resbeNode.runAction(floatActionLoop)
                }
            } else {
                fatalError("Failed to load the resbe image.")
            }
        }

    }
//    let image = UIImage(named: "tree.png")
//    let imageView = UIImageView(image: image)
//    imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//    imageView.contentMode = .scaleAspectFit
//
//    // Create a plane with the same dimensions as the image view
//    let imagePlane = SCNPlane(width: 0.2, height: 0.2)
//    imagePlane.firstMaterial?.diffuse.contents = imageView
//
//    // Create a node with the image plane and position it
//    let imageNode = SCNNode(geometry: imagePlane)
//    imageNode.position = SCNVector3(x: 0, y: -1, z: -1)


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
}





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
