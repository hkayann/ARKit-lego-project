import UIKit
import SceneKit
import ARKit
import ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

    var anchors: [ARAnchor] = []
    var anchorNodes: [ARAnchor: SCNNode] = [:]
    var isGreenTapped = false
    var isPinkTapped = false
    var isPurpleTapped = false
    var isOrangeTapped = false
    var isYellowTapped = false
    var isBlueTapped = false
    var isBlackTapped = false
    
    @IBOutlet var sceneView: ARSCNView!
    private var yellowBoxNode: SCNReferenceNode?
    private var purpleBoxNode: SCNReferenceNode?
    private var greenBoxNode: SCNReferenceNode?
    private var pinkBoxNode: SCNReferenceNode?
    private var orangeBoxNode: SCNReferenceNode?
    private var blueBoxNode: SCNReferenceNode?
    private var blackBoxNode: SCNReferenceNode?
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
        let blueBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0, -1, -2, 1)])
        let blueAnchor = ARAnchor(name: "blueAnchor", transform: blueBoxAnchorTransform)
        let blackBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0, -1, -3, 1)])
        let blackAnchor = ARAnchor(name: "blackAnchor", transform: blackBoxAnchorTransform)
        let greenBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, -1, -2, 1)])
        let greenAnchor = ARAnchor(name: "greenAnchor", transform: greenBoxAnchorTransform)
        let resbeAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, -0.5, -2, 1)])
        let resbeAnchor = ARAnchor(name: "resbeAnchor", transform: resbeAnchorTransform)
        let pinkBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(-0.5, -1, -2, 1)])
        let pinkAnchor = ARAnchor(name: "pinkAnchor", transform: pinkBoxAnchorTransform)
        let orangeBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0, -1, -4, 1)])
        let orangeAnchor = ARAnchor(name: "orangeAnchor", transform: orangeBoxAnchorTransform)
        let purpleBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(0.5, -1, -3, 1)])
        let purpleAnchor = ARAnchor(name: "purpleAnchor", transform: purpleBoxAnchorTransform)
        let yellowBoxAnchorTransform = simd_float4x4([
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),  // Adjust the z-coordinate as needed
            SIMD4<Float>(-0.5, -1, -3, 1)])
        let yellowAnchor = ARAnchor(name: "yellowAnchor", transform: yellowBoxAnchorTransform)

        // Add anchor for boxes to the AR session
        sceneView.session.add(anchor: blueAnchor)
        sceneView.session.add(anchor: greenAnchor)
        sceneView.session.add(anchor: pinkAnchor)
        sceneView.session.add(anchor: orangeAnchor)
        sceneView.session.add(anchor: purpleAnchor)
        sceneView.session.add(anchor: yellowAnchor)
        sceneView.session.add(anchor: blackAnchor)

        // Add anchor for boxes to the AR session
        sceneView.session.add(anchor: resbeAnchor)
        /*
         3D OBJECTS END
         */

        // Add tap gesture recognizer to the sceneView
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(objectTapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer2)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func addImageNode(imageName: String, duration: TimeInterval, toNode node: SCNNode) {
        if let image = UIImage(named: imageName) {
            // Perform UI operations on the main thread
            DispatchQueue.main.async {
                // Create an image view to display the image
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                imageView.contentMode = .scaleAspectFit

                // Create a plane with the same dimensions as the image view
                let imagePlane = SCNPlane(width: 0.5, height: 0.5)
                imagePlane.firstMaterial?.diffuse.contents = imageView

                // Create a node with the image plane and adjust its position
                let imageNode = SCNNode(geometry: imagePlane)
                node.addChildNode(imageNode)

                // Apply the floating animation to the box
                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: duration)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                imageNode.runAction(floatActionLoop)
            }
        } else {
            fatalError("Failed to load the \(imageName) image.")
        }
    }


    @objc func objectTapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, options: nil)
        let hitNode = hitTestResults.first?.node
        // Necessary to see the names.
        let hitNodeName = hitNode?.name
        print("\(hitNodeName) Tapped")
        if hitNodeName == "Box005_09___Green_0" {
            isGreenTapped = !isGreenTapped
            // Now you can use the isGreenTapped flag to determine the status of the green box
            if isGreenTapped {
                print("Green box is now tapped.")
                for (anchor, node) in anchorNodes {
                    if let anchorName = anchor.name, anchorName == "resbeAnchor" {
                        print("Found anchor with name: \(anchorName)")
                        addImageNode(imageName: "resbeGreen.png", duration: 1.1, toNode: node)
                    }
                }
            } else {
                print("Green box is now untapped.")
                for (anchor, node) in anchorNodes {
                    if let anchorName = anchor.name, anchorName == "resbeAnchor" {
                        for childNode in node.childNodes {
                            if childNode.geometry is SCNPlane {
                                childNode.removeFromParentNode()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        func addFloatingBox(to anchor: ARAnchor, with resourceName: String, animationDuration: TimeInterval) {
            guard let boxUrl = Bundle.main.url(forResource: resourceName, withExtension: "usdz"),
                  let boxNode = SCNReferenceNode(url: boxUrl) else {
                fatalError("Failed to find \(resourceName).usdz in the bundle.")
            }
            
            // Load, rotate, scale.
            boxNode.eulerAngles = SCNVector3(-rotationAngle, 0, 0)
            boxNode.scale = SCNVector3(0.001, 0.001, 0.001)
            boxNode.load()
            
            // Add the box node as a child of the anchor's node
            node.addChildNode(boxNode)
            
            // Create a floating animation
            let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: animationDuration)
            floatUpAction.timingMode = .easeInEaseOut
            let floatDownAction = floatUpAction.reversed()
            let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
            let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
            
            // Apply the floating animation to the box
            boxNode.runAction(floatActionLoop)
        }
        print("Anchor added to the scene.")
        // print(anchor.name)
        anchors.append(anchor)
        let rotationAngle = Float.pi / 2.0 // 90 degrees in radians
        if anchor.name == "resbeAnchor" {
            // Store the node corresponding to the resbeAnchor in the dictionary
            anchorNodes[anchor] = node
            print("Found anchor with name: \(anchor.name ?? "Unnamed anchor")")
        }
        if anchor.name == "blueAnchor" {
            addFloatingBox(to: anchor, with: "blueBoxText", animationDuration: 1.5)
        }
        if anchor.name == "pinkAnchor" {
            addFloatingBox(to: anchor, with: "pinkBoxText", animationDuration: 1.4)
        }
        if anchor.name == "yellowAnchor" {
            addFloatingBox(to: anchor, with: "yellowBoxText", animationDuration: 1.3)
        }
        if anchor.name == "orangeAnchor" {
            addFloatingBox(to: anchor, with: "orangeBoxText", animationDuration: 1.2)
        }
        if anchor.name == "purpleAnchor" {
            addFloatingBox(to: anchor, with: "purpleBoxText", animationDuration: 1.1)
        }
        if anchor.name == "greenAnchor" {
            addFloatingBox(to: anchor, with: "greenBoxText", animationDuration: 1.0)
        }
        if anchor.name == "blackAnchor" {
            addFloatingBox(to: anchor, with: "blackBoxText", animationDuration: 1.6)
        }
    }
    
    func accessAllAnchors() {
        print("Accessing all anchors:")
        for anchor in anchors {
            print(anchor.name ?? "Unnamed anchor")
            // Do whatever you need with each anchor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
}

//        if let hitNodeName = hitNode?.name, hitNodeName == "Box005_02___Default_0" {
//            // Remove the qMarkNode from the parent node
//            // qMarkNode?.removeFromParentNode()
//            // Now that the box is removed, show the image
//            let image = UIImage(named: "tree.png")
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//            imageView.contentMode = .scaleAspectFit
//
//            // Create a plane with the same dimensions as the image view
//            let imagePlane = SCNPlane(width: 0.2, height: 0.2)
//            imagePlane.firstMaterial?.diffuse.contents = imageView
//
//            // Create a node with the image plane and position it
//            let imageNode = SCNNode(geometry: imagePlane)
//            imageNode.position = SCNVector3(x: 0, y: -1, z: -1)
//
//            // Add the image node to the scene
//            sceneView.scene.rootNode.addChildNode(imageNode)
//        }

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
