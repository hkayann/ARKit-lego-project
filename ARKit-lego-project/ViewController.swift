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
    var isBlackHubTapped = false
    var isBlackCentreTapped = false
    
    @IBOutlet var sceneView: ARSCNView!
    private var yellowBoxNode: SCNReferenceNode?
    private var purpleBoxNode: SCNReferenceNode?
    private var greenBoxNode: SCNReferenceNode?
    private var pinkBoxNode: SCNReferenceNode?
    private var orangeBoxNode: SCNReferenceNode?
    private var blueBoxNode: SCNReferenceNode?
    private var blackBoxNode: SCNReferenceNode?
    private var blackBoxHubNode: SCNReferenceNode?
    private var blackBoxCentreNode: SCNReferenceNode?
    private var shelfNode: SCNReferenceNode?
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
        directionalLight.intensity = 250
        directionalLight.castsShadow = false
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.position = SCNVector3(0, 10, 10) // Adjust the position as needed
        // scene.rootNode.addChildNode(directionalLightNode)
        /*
         LIGHTS END
         */
        /*
         3D OBJECTS START
         */
        func createARAnchorWithPosition(name: String, position: SIMD3<Float>) -> ARAnchor {
            let transform = matrix_identity_float4x4
            var anchorTransform = transform
            anchorTransform.columns.3.x = position.x
            anchorTransform.columns.3.y = position.y
            anchorTransform.columns.3.z = position.z
            let anchor = ARAnchor(name: name, transform: anchorTransform)
            return anchor
        }
        // Box anchors
        let greenAnchor = createARAnchorWithPosition(name: "greenAnchor", position: SIMD3<Float>(0.75, -0.2, -2))
        let pinkAnchor = createARAnchorWithPosition(name: "pinkAnchor", position: SIMD3<Float>(0.45, -0.2, -2))
        let orangeAnchor = createARAnchorWithPosition(name: "orangeAnchor", position: SIMD3<Float>(0.15, -0.2, -2))
        let blueAnchor = createARAnchorWithPosition(name: "blueAnchor", position: SIMD3<Float>(-0.45, -0.2, -2))
        let purpleAnchor = createARAnchorWithPosition(name: "purpleAnchor", position: SIMD3<Float>(-1.05, -0.2, -2))
        let yellowAnchor = createARAnchorWithPosition(name: "yellowAnchor", position: SIMD3<Float>(-0.75, -0.2, -2))
        let blackAnchor = createARAnchorWithPosition(name: "blackAnchor", position: SIMD3<Float>(-0.15, -0.2, -2))
        let blackAnchorHub = createARAnchorWithPosition(name: "blackAnchorHub", position: SIMD3<Float>(-0.15, -0.35, -2))
        let blackAnchorCentre = createARAnchorWithPosition(name: "blackAnchorCentre", position: SIMD3<Float>(-0.15, -0.05, -2))
        let shelfAnchor = createARAnchorWithPosition(name: "shelfAnchor", position: SIMD3<Float>(-1.55, -0.2, -1.5))
        
        // Image anchors blue - health
        let aaciotAnchor = createARAnchorWithPosition(name: "aaciotAnchor", position: SIMD3<Float>(-0.77, -0.55, -0.82))
        let beclAnchor = createARAnchorWithPosition(name: "beclAnchor", position: SIMD3<Float>(-0.85, -0.55, -0.3))
        let cpsociamAnchor = createARAnchorWithPosition(name: "cpsociamAnchor", position: SIMD3<Float>(-0.85, -0.35, -0.34))
        let cyferAnchor = createARAnchorWithPosition(name: "cyferAnchor", position: SIMD3<Float>(-0.69, -0.55, -0.3))
        let dashAnchor = createARAnchorWithPosition(name: "dashAnchor", position: SIMD3<Float>(-0.84, -0.55, -0.40))
        let hipsterAnchor = createARAnchorWithPosition(name: "hipsterAnchor", position: SIMD3<Float>(-0.69, -0.35, -0.31))
        let peiesiAnchor = createARAnchorWithPosition(name: "peiesiAnchor", position: SIMD3<Float>(-0.68, -0.55, -0.52))
        let prismAnchor = createARAnchorWithPosition(name: "prismAnchor", position: SIMD3<Float>(0.3, -0.55, -0.75))
        let pristineAnchor = createARAnchorWithPosition(name: "pristineAnchor", position: SIMD3<Float>(-0.69, -0.45, -0.33))
        let redaidAnchor = createARAnchorWithPosition(name: "redaidAnchor", position: SIMD3<Float>(-0.87, -0.55, -0.45))
        let regmedtechAnchor = createARAnchorWithPosition(name: "regmedtechAnchor", position: SIMD3<Float>(-0.85, -0.45, -0.32))
        let senthplusAnchor = createARAnchorWithPosition(name: "senthplusAnchor", position: SIMD3<Float>(-0.81, -0.55, -0.77))
        let senthAnchor = createARAnchorWithPosition(name: "senthAnchor", position: SIMD3<Float>(0.4, -0.5, -2))
        
        // Image anchors yellow - transport
        let aikemaAnchor = createARAnchorWithPosition(name: "aikemaAnchor", position: SIMD3<Float>(-0.47, -0.55, -1.0))
        let amloeAnchor = createARAnchorWithPosition(name: "amloeAnchor", position: SIMD3<Float>(0.33, -0.55, -1.6))
        let costcmorsAnchor = createARAnchorWithPosition(name: "costcmorsAnchor", position: SIMD3<Float>(0.32, -0.55, -1.3))
        let ddipiotAnchor = createARAnchorWithPosition(name: "ddipiotAnchor", position: SIMD3<Float>(0.18, -0.55, -1.42))
        let geosecAnchor = createARAnchorWithPosition(name: "geosecAnchor", position: SIMD3<Float>(0.32, -0.55, -1.25))
        let magicAnchor = createARAnchorWithPosition(name: "magicAnchor", position: SIMD3<Float>(0.91, -0.55, -1.58))
        let maiseAnchor = createARAnchorWithPosition(name: "maiseAnchor", position: SIMD3<Float>(-0.37, -0.55, -1.0))
        let pcarsAnchor = createARAnchorWithPosition(name: "pcarsAnchor", position: SIMD3<Float>(0, -0.55, -0.95))
        let roadmappAnchor = createARAnchorWithPosition(name: "roadmappAnchor", position: SIMD3<Float>(0.14, -0.55, -1.24))
        let tmdaAnchor = createARAnchorWithPosition(name: "tmdaAnchor", position: SIMD3<Float>(0, -0.55, -1.26))
        let tomsacAnchor = createARAnchorWithPosition(name: "tomsacAnchor", position: SIMD3<Float>(0.23, -0.55, -1.5))
        let umisAnchor = createARAnchorWithPosition(name: "umisAnchor", position: SIMD3<Float>(-0.68, -0.55, -1.33))
        
        // Image anchors pink - supply
        let crateAnchor = createARAnchorWithPosition(name: "crateAnchor", position: SIMD3<Float>(-0.87, -0.45, -0.47))
        let digiportAnchor = createARAnchorWithPosition(name: "digiportAnchor", position: SIMD3<Float>(0.55, -0.55, -0.75))
        let ebisplusAnchor = createARAnchorWithPosition(name: "ebisplusAnchor", position: SIMD3<Float>(-0.51, -0.55, -1.65))
        let elliottAnchor = createARAnchorWithPosition(name: "elliottAnchor", position: SIMD3<Float>(0.2, -0.55, -0.98))
        let eviotAnchor = createARAnchorWithPosition(name: "eviotAnchor", position: SIMD3<Float>(-0.4, -0.5, -2))
        let iamAnchor = createARAnchorWithPosition(name: "iamAnchor", position: SIMD3<Float>(-0.50, -0.55, -1.95))
        let iceodsAnchor = createARAnchorWithPosition(name: "iceodsAnchor", position: SIMD3<Float>(1.20, -0.55, -1.78))
        let iotdependsAnchor = createARAnchorWithPosition(name: "iotdependsAnchor", position: SIMD3<Float>(0.95, -0.55, -1.70))
        let isctiesAnchor = createARAnchorWithPosition(name: "isctiesAnchor", position: SIMD3<Float>(-0.50, -0.55, -2.05))
        let logistics40Anchor = createARAnchorWithPosition(name: "logistics40Anchor", position: SIMD3<Float>(0.81, -0.45, -1.82))
        let massAnchor = createARAnchorWithPosition(name: "massAnchor", position: SIMD3<Float>(-0.78, -0.55, -1.2))
        let nusbiotAnchor = createARAnchorWithPosition(name: "nusbiotAnchor", position: SIMD3<Float>(0.45, -0.55, -1.61))
        let powersprintAnchor = createARAnchorWithPosition(name: "powersprintAnchor", position: SIMD3<Float>(0, -0.55, -0.25))
        let pswarmsAnchor = createARAnchorWithPosition(name: "pswarmsAnchor", position: SIMD3<Float>(-0.91, -0.45, -1.45))
        let secqbsAnchor = createARAnchorWithPosition(name: "secqbsAnchor", position: SIMD3<Float>(0.43, -0.55, -1.7))
        let sofiotsAnchor = createARAnchorWithPosition(name: "sofiotsAnchor", position: SIMD3<Float>(0.25, -0.45, -1.85))
        
        // Image anchors purple - agritech
        let cyfooAnchor = createARAnchorWithPosition(name: "cyfooAnchor", position: SIMD3<Float>(-0.18, -0.55, -0.3))
        let farmAnchor = createARAnchorWithPosition(name: "farmAnchor", position: SIMD3<Float>(-0.45, -0.55, -0.3))
        
        // Image anchors green - ambient
        let resbeAnchor = createARAnchorWithPosition(name: "resbeAnchor", position: SIMD3<Float>(0.32, -0.45, -1.05))
        let ariotAnchor = createARAnchorWithPosition(name: "ariotAnchor", position: SIMD3<Float>(-0.2, -0.55, -0.95))
        let depriotAnchor = createARAnchorWithPosition(name: "depriotAnchor", position: SIMD3<Float>(0.3, -0.55, -0.6))
        let disscAnchor = createARAnchorWithPosition(name: "disscAnchor", position: SIMD3<Float>(0.2, -0.55, -0.65))
        let erAnchor = createARAnchorWithPosition(name: "erAnchor", position: SIMD3<Float>(-0.91, -0.55, -1.65))
        let etAnchor = createARAnchorWithPosition(name: "etAnchor", position: SIMD3<Float>(0.3, -0.45, -0.80))
        let evaluateAnchor = createARAnchorWithPosition(name: "evaluateAnchor", position: SIMD3<Float>(-0.13, -0.55, -0.95))
        let exiotAnchor = createARAnchorWithPosition(name: "exiotAnchor", position: SIMD3<Float>(-0.47, -0.45, -1.15))
        let giotAnchor = createARAnchorWithPosition(name: "giotAnchor", position: SIMD3<Float>(-0.85, -0.55, -1.00))
        let iceaiAnchor = createARAnchorWithPosition(name: "iceaiAnchor", position: SIMD3<Float>(0.25, -0.45, -0.28))
        let idiceAnchor = createARAnchorWithPosition(name: "idiceAnchor", position: SIMD3<Float>(0.1, -0.55, -0.6))
        let iotinparkAnchor = createARAnchorWithPosition(name: "iotinparkAnchor", position: SIMD3<Float>(-0.3, -0.55, -0.85))
        let iototAnchor = createARAnchorWithPosition(name: "iototAnchor", position: SIMD3<Float>(-0.90, -0.55, -1.75))
        let macsAnchor = createARAnchorWithPosition(name: "macsAnchor", position: SIMD3<Float>(-0.03, -0.55, -0.75))
        let ppiteeAnchor = createARAnchorWithPosition(name: "ppiteeAnchor", position: SIMD3<Float>(-0.23, -0.55, -0.85))
        let ppiemAnchor = createARAnchorWithPosition(name: "ppiemAnchor", position: SIMD3<Float>(-0.52, -0.45, -0.60))
        let priviotAnchor = createARAnchorWithPosition(name: "priviotAnchor", position: SIMD3<Float>(0.3, -0.55, -0.88))
        let ptheatAnchor = createARAnchorWithPosition(name: "ptheatAnchor", position: SIMD3<Float>(-0.93, -0.55, -0.98))
        let pubviaAnchor = createARAnchorWithPosition(name: "pubviaAnchor", position: SIMD3<Float>(0.32, -0.35, -1.1))
        let raceAnchor = createARAnchorWithPosition(name: "raceAnchor", position: SIMD3<Float>(-1.50, -0.065, -1.25))
        let reappearAnchor = createARAnchorWithPosition(name: "reappearAnchor", position: SIMD3<Float>(0.35, -0.55, -1.0))
        let recopsAnchor = createARAnchorWithPosition(name: "recopsAnchor", position: SIMD3<Float>(0, -0.55, -0.7))
        let retipsAnchor = createARAnchorWithPosition(name: "retipsAnchor", position: SIMD3<Float>(0.27, -0.55, -0.72))
        let semiotAnchor = createARAnchorWithPosition(name: "semiotAnchor", position: SIMD3<Float>(0.15, -0.55, -0.55))
        let spiseAnchor = createARAnchorWithPosition(name: "spiseAnchor", position: SIMD3<Float>(-1.2, -0.55, -1.08))
        let stipsAnchor = createARAnchorWithPosition(name: "stipsAnchor", position: SIMD3<Float>(0.05, -0.55, -1.03))
        let teamAnchor = createARAnchorWithPosition(name: "teamAnchor", position: SIMD3<Float>(-0.07, -0.55, -0.45))
        let thingsdartAnchor = createARAnchorWithPosition(name: "thingsdartAnchor", position: SIMD3<Float>(-0.3, -0.55, -1.02))
        let udaiotAnchor = createARAnchorWithPosition(name: "udaiotAnchor", position: SIMD3<Float>(0.18, -0.55, -0.41))
        
        // Image anchors orange - infrastructure
        let blataAnchor = createARAnchorWithPosition(name: "blataAnchor", position: SIMD3<Float>(-0.78, -0.45, -1.25))
        let blockitAnchor = createARAnchorWithPosition(name: "blockitAnchor", position: SIMD3<Float>(0, -0.55, -0.36))
        let botthingsAnchor = createARAnchorWithPosition(name: "botthingsAnchor", position: SIMD3<Float>(-0.2, -0.55, -0.39))
        let btsAnchor = createARAnchorWithPosition(name: "btsAnchor", position: SIMD3<Float>(0, -0.55, -0.42))
        let cedeAnchor = createARAnchorWithPosition(name: "cedeAnchor", position: SIMD3<Float>(-1.50, -0.25, -1.70))
        let cracsAnchor = createARAnchorWithPosition(name: "cracsAnchor", position: SIMD3<Float>(-0.30, -0.55, -0.43))
        let csiplusAnchor = createARAnchorWithPosition(name: "csiplusAnchor", position: SIMD3<Float>(-0.30, -0.55, -0.48))
        let csiAnchor = createARAnchorWithPosition(name: "csiAnchor", position: SIMD3<Float>(0.4, -0.5, -2))
        let cyberhygieneAnchor = createARAnchorWithPosition(name: "cyberhygieneAnchor", position: SIMD3<Float>(-0.68, -0.55, -0.6))
        let dtcemAnchor = createARAnchorWithPosition(name: "dtcemAnchor", position: SIMD3<Float>(0.71, -0.55, -1.78))
        let fireAnchor = createARAnchorWithPosition(name: "fireAnchor", position: SIMD3<Float>(-0.34, -0.55, -1.40))
        let gistAnchor = createARAnchorWithPosition(name: "gistAnchor", position: SIMD3<Float>(-1.50, -0.420, -1.70))
        let graphsecAnchor = createARAnchorWithPosition(name: "graphsecAnchor", position: SIMD3<Float>(0.23, -0.55, -1.8))
        let healthiAnchor = createARAnchorWithPosition(name: "healthiAnchor", position: SIMD3<Float>(-0.49, -0.55, -0.35))
        let icecAnchor = createARAnchorWithPosition(name: "icecAnchor", position: SIMD3<Float>(-0.3, -0.55, -1.67))
        let iotincontrolAnchor = createARAnchorWithPosition(name: "iotincontrolAnchor", position: SIMD3<Float>(-0.49, -0.55, -0.55))
        let iotmspAnchor = createARAnchorWithPosition(name: "iotmspAnchor", position: SIMD3<Float>(0.09, -0.55, -0.47))
        let iotobservatoryAnchor = createARAnchorWithPosition(name: "iotobservatoryAnchor", position: SIMD3<Float>(-0.64, -0.55, -0.65))
        let nipcAnchor = createARAnchorWithPosition(name: "nipcAnchor", position: SIMD3<Float>(-0.1, -0.55, -1.5))
        let p2pioetAnchor = createARAnchorWithPosition(name: "p2pioetAnchor", position: SIMD3<Float>(-0.18, -0.55, -1.2))
        let petrasdsfAnchor = createARAnchorWithPosition(name: "petrasdsfAnchor", position: SIMD3<Float>(-1.50, -0.25, -1.4))
        let power2Anchor = createARAnchorWithPosition(name: "power2Anchor", position: SIMD3<Float>(-0.13, -0.45, -1.1))
        let prioteAnchor = createARAnchorWithPosition(name: "prioteAnchor", position: SIMD3<Float>(-0.25, -0.55, -0.5))
        let retconAnchor = createARAnchorWithPosition(name: "retconAnchor", position: SIMD3<Float>(-1.50, -0.065, -1.40))
        let rioteAnchor = createARAnchorWithPosition(name: "rioteAnchor", position: SIMD3<Float>(-0.48, -0.55, -1.40))
        let roastiotAnchor = createARAnchorWithPosition(name: "roastiotAnchor", position: SIMD3<Float>(-1.50, -0.25, -1.25))
        let rsiotAnchor = createARAnchorWithPosition(name: "rsiotAnchor", position: SIMD3<Float>(-0.35, -0.55, -1.34))
        let sdriotss2Anchor = createARAnchorWithPosition(name: "sdriotss2Anchor", position: SIMD3<Float>(-1.50, -0.25, -1.55))
        let sdriotssAnchor = createARAnchorWithPosition(name: "sdriotssAnchor", position: SIMD3<Float>(0.4, -0.5, -2))
        let secrisAnchor = createARAnchorWithPosition(name: "secrisAnchor", position: SIMD3<Float>(-0.60, -0.55, -1.04))
        let spiotshAnchor = createARAnchorWithPosition(name: "spiotshAnchor", position: SIMD3<Float>(0.32, -0.55, -0.85))
        let tansecAnchor = createARAnchorWithPosition(name: "tansecAnchor", position: SIMD3<Float>(0.15, -0.55, -0.25))
        let trusdedAnchor = createARAnchorWithPosition(name: "trusdedAnchor", position: SIMD3<Float>(-0.71, -0.55, -1.0))
        let uncanaiAnchor = createARAnchorWithPosition(name: "uncanaiAnchor", position: SIMD3<Float>(-0.62, -0.55, -1.63))
        
        // Add anchor for boxes to the AR session
        sceneView.session.add(anchor: blueAnchor)
        sceneView.session.add(anchor: greenAnchor)
        sceneView.session.add(anchor: pinkAnchor)
        sceneView.session.add(anchor: orangeAnchor)
        sceneView.session.add(anchor: purpleAnchor)
        sceneView.session.add(anchor: yellowAnchor)
        // sceneView.session.add(anchor: blackAnchor)
        sceneView.session.add(anchor: blackAnchorHub)
        sceneView.session.add(anchor: blackAnchorCentre)
        sceneView.session.add(anchor: shelfAnchor)
        
        // Add anchor for images to the AR session
        sceneView.session.add(anchor: resbeAnchor)
        
        sceneView.session.add(anchor: aaciotAnchor)
        sceneView.session.add(anchor: aikemaAnchor)
        sceneView.session.add(anchor: amloeAnchor)
        sceneView.session.add(anchor: ariotAnchor)
        sceneView.session.add(anchor: beclAnchor)
        sceneView.session.add(anchor: blataAnchor)
        sceneView.session.add(anchor: blockitAnchor)
        sceneView.session.add(anchor: botthingsAnchor)
        sceneView.session.add(anchor: btsAnchor)
        sceneView.session.add(anchor: cedeAnchor)
        sceneView.session.add(anchor: costcmorsAnchor)
        sceneView.session.add(anchor: cpsociamAnchor)
        sceneView.session.add(anchor: cracsAnchor)
        sceneView.session.add(anchor: crateAnchor)
        sceneView.session.add(anchor: csiplusAnchor)
        sceneView.session.add(anchor: csiAnchor)
        sceneView.session.add(anchor: cyberhygieneAnchor)
        sceneView.session.add(anchor: cyferAnchor)
        sceneView.session.add(anchor: cyfooAnchor)
        sceneView.session.add(anchor: dashAnchor)
        sceneView.session.add(anchor: ddipiotAnchor)
        sceneView.session.add(anchor: depriotAnchor)
        sceneView.session.add(anchor: digiportAnchor)
        sceneView.session.add(anchor: disscAnchor)
        sceneView.session.add(anchor: dtcemAnchor)
        sceneView.session.add(anchor: ebisplusAnchor)
        sceneView.session.add(anchor: elliottAnchor)
        sceneView.session.add(anchor: erAnchor)
        sceneView.session.add(anchor: etAnchor)
        sceneView.session.add(anchor: evaluateAnchor)
        sceneView.session.add(anchor: eviotAnchor)
        sceneView.session.add(anchor: exiotAnchor)
        sceneView.session.add(anchor: farmAnchor)
        sceneView.session.add(anchor: fireAnchor)
        sceneView.session.add(anchor: giotAnchor)
        sceneView.session.add(anchor: geosecAnchor)
        sceneView.session.add(anchor: gistAnchor)
        sceneView.session.add(anchor: graphsecAnchor)
        sceneView.session.add(anchor: healthiAnchor)
        sceneView.session.add(anchor: hipsterAnchor)
        sceneView.session.add(anchor: iamAnchor)
        sceneView.session.add(anchor: iceaiAnchor)
        sceneView.session.add(anchor: iceodsAnchor)
        sceneView.session.add(anchor: icecAnchor)
        sceneView.session.add(anchor: idiceAnchor)
        sceneView.session.add(anchor: iotdependsAnchor)
        sceneView.session.add(anchor: iotincontrolAnchor)
        sceneView.session.add(anchor: iotinparkAnchor)
        sceneView.session.add(anchor: iotmspAnchor)
        sceneView.session.add(anchor: iotobservatoryAnchor)
        sceneView.session.add(anchor: iototAnchor)
        sceneView.session.add(anchor: isctiesAnchor)
        sceneView.session.add(anchor: logistics40Anchor)
        sceneView.session.add(anchor: macsAnchor)
        sceneView.session.add(anchor: magicAnchor)
        sceneView.session.add(anchor: maiseAnchor)
        sceneView.session.add(anchor: massAnchor)
        sceneView.session.add(anchor: nipcAnchor)
        sceneView.session.add(anchor: nusbiotAnchor)
        sceneView.session.add(anchor: pcarsAnchor)
        sceneView.session.add(anchor: ppiteeAnchor)
        sceneView.session.add(anchor: p2pioetAnchor)
        sceneView.session.add(anchor: peiesiAnchor)
        sceneView.session.add(anchor: petrasdsfAnchor)
        sceneView.session.add(anchor: powersprintAnchor)
        sceneView.session.add(anchor: power2Anchor)
        sceneView.session.add(anchor: ppiemAnchor)
        sceneView.session.add(anchor: prioteAnchor)
        sceneView.session.add(anchor: prismAnchor)
        sceneView.session.add(anchor: pristineAnchor)
        sceneView.session.add(anchor: priviotAnchor)
        sceneView.session.add(anchor: pswarmsAnchor)
        sceneView.session.add(anchor: ptheatAnchor)
        sceneView.session.add(anchor: pubviaAnchor)
        sceneView.session.add(anchor: raceAnchor)
        sceneView.session.add(anchor: reappearAnchor)
        sceneView.session.add(anchor: recopsAnchor)
        sceneView.session.add(anchor: redaidAnchor)
        sceneView.session.add(anchor: regmedtechAnchor)
        sceneView.session.add(anchor: retconAnchor)
        sceneView.session.add(anchor: retipsAnchor)
        sceneView.session.add(anchor: rioteAnchor)
        sceneView.session.add(anchor: roadmappAnchor)
        sceneView.session.add(anchor: roastiotAnchor)
        sceneView.session.add(anchor: rsiotAnchor)
        sceneView.session.add(anchor: sdriotss2Anchor)
        sceneView.session.add(anchor: sdriotssAnchor)
        sceneView.session.add(anchor: secqbsAnchor)
        sceneView.session.add(anchor: secrisAnchor)
        sceneView.session.add(anchor: semiotAnchor)
        sceneView.session.add(anchor: senthplusAnchor)
        sceneView.session.add(anchor: senthAnchor)
        sceneView.session.add(anchor: sofiotsAnchor)
        sceneView.session.add(anchor: spiotshAnchor)
        sceneView.session.add(anchor: spiseAnchor)
        sceneView.session.add(anchor: stipsAnchor)
        sceneView.session.add(anchor: tansecAnchor)
        sceneView.session.add(anchor: teamAnchor)
        sceneView.session.add(anchor: thingsdartAnchor)
        sceneView.session.add(anchor: tmdaAnchor)
        sceneView.session.add(anchor: tomsacAnchor)
        sceneView.session.add(anchor: trusdedAnchor)
        sceneView.session.add(anchor: udaiotAnchor)
        sceneView.session.add(anchor: umisAnchor)
        sceneView.session.add(anchor: uncanaiAnchor)
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
    
    func addImageNode(imageName: String, identifier: String, duration: TimeInterval, rotationAngleRadians: Float, toNode node: SCNNode) {
        if let image = UIImage(named: imageName) {
            DispatchQueue.main.async {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: image.size.width * 0.17, height: image.size.height * 0.17)
                imageView.contentMode = .scaleAspectFit

                let imagePlane = SCNPlane(width: imageView.frame.size.width / 1000, height: imageView.frame.size.height / 1000)
                imagePlane.firstMaterial?.diffuse.contents = imageView
                imagePlane.firstMaterial?.isDoubleSided = true

                let imageNode = SCNNode(geometry: imagePlane)
                imageNode.name = identifier
                node.addChildNode(imageNode)

                let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: duration)
                floatUpAction.timingMode = .easeInEaseOut
                let floatDownAction = floatUpAction.reversed()
                let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
                let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
                imageNode.runAction(floatActionLoop)
                
                let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(rotationAngleRadians), z: 0, duration: 0)
                imageNode.runAction(rotateAction)
            }
        } else {
            fatalError("Failed to load the \(imageName) image.")
        }
    }


    @objc func objectTapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let options: [SCNHitTestOption: Any] = [
            .boundingBoxOnly: false,
            .ignoreHiddenNodes: true,
        ]
        let hitTestResults = sceneView.hitTest(tapLocation, options: options)
        let hitNode = hitTestResults.first?.node
        // Necessary to see the names.
        let hitNodeName = hitNode?.name
        print("\(hitNodeName) Tapped")
        func openWebsiteIfNodeTapped(imageName: String, websiteURL: String) {
            if let hitNodeName = hitNode?.name, hitNodeName == imageName {
                if let url = URL(string: websiteURL) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        openWebsiteIfNodeTapped(imageName: "aaciotBlue.png", websiteURL: "https://petras-iot.org/project/authentication-and-access-control-with-multiple-iot-devices-aaciot/")
        openWebsiteIfNodeTapped(imageName: "aikemaYellow.png", websiteURL: "https://petras-iot.org/project/aikema/")
        openWebsiteIfNodeTapped(imageName: "amloeYellow.png", websiteURL: "https://petras-iot.org/project/adversarial-machine-learning-on-the-edge-amloe/")
        openWebsiteIfNodeTapped(imageName: "ariotGreen.png", websiteURL: "https://petras-iot.org/project/a-roadmap-for-the-internet-of-things-in-queen-elizabeth-olympic-park-ariot/")
        openWebsiteIfNodeTapped(imageName: "beclBlue.png", websiteURL: "https://petras-iot.org/project/building-evidence-base-for-cop-legislation-becl/")
        openWebsiteIfNodeTapped(imageName: "blataOrange.png", websiteURL: "https://petras-iot.org/project/bridging-the-gap-between-legal-and-technical-anonymisation/")
        openWebsiteIfNodeTapped(imageName: "blockitOrange.png", websiteURL: "https://petras-iot.org/project/blockchain-empowered-infrastructure-for-iot-blockit/")
        openWebsiteIfNodeTapped(imageName: "botthingsOrange.png", websiteURL: "https://petras-iot.org/project/botthings/")
        openWebsiteIfNodeTapped(imageName: "btsOrange.png", websiteURL: "https://petras-iot.org/project/self-sustained-blockchain-based-treasury-system-bts/")
        openWebsiteIfNodeTapped(imageName: "cedeOrange.png", websiteURL: "https://petras-iot.org/project/cloudlet-enhanced-devices-at-the-edge-cede/")
        openWebsiteIfNodeTapped(imageName: "costcmorsYellow.png", websiteURL: "https://petras-iot.org/project/cognitive-and-socio-technical-cybersecurity-in-modern-railway-system-costcmors/")
        openWebsiteIfNodeTapped(imageName: "cp-sociamBlue.png", websiteURL: "https://petras-iot.org/project/cp-sociam/")
        openWebsiteIfNodeTapped(imageName: "cracsOrange.png", websiteURL: "https://petras-iot.org/project/cyber-risk-assessment-for-coupled-systems-cracs/")
        openWebsiteIfNodeTapped(imageName: "cratePink.png", websiteURL: "https://petras-iot.org/project/impact-of-cyber-risk-at-the-edge-cyber-risk-analytics-and-artificial-intelligence-crate/")
        openWebsiteIfNodeTapped(imageName: "csi+Orange.png", websiteURL: "https://petras-iot.org/project/developing-a-consumer-security-index-for-domestic-iot-devices-plus-csi/")
        openWebsiteIfNodeTapped(imageName: "csiOrange.png", websiteURL: "https://petras-iot.org/project/developing-a-consumer-security-index-for-consumer-iot-devices-csi/")
        openWebsiteIfNodeTapped(imageName: "cyberhygieneOrange.png", websiteURL: "https://petras-iot.org/project/cyberhygiene/")
        openWebsiteIfNodeTapped(imageName: "cyferBlue.png", websiteURL: "https://petras-iot.org/project/cyber-security-and-privacy-in-fertility-technologies-cyfer/")
        openWebsiteIfNodeTapped(imageName: "cyfooPurple.png", websiteURL: "https://petras-iot.org/project/cybersecurity-for-food-security-cyfoo-2/")
        openWebsiteIfNodeTapped(imageName: "dashBlue.png", websiteURL: "https://petras-iot.org/project/data-analysis-and-iot-solutions-for-healthcare-dash/")
        openWebsiteIfNodeTapped(imageName: "ddip-iotYellow.png", websiteURL: "https://petras-iot.org/project/designing-dynamic-insurance-policies-using-iot-ddip-iot/")
        openWebsiteIfNodeTapped(imageName: "depriotGreen.png", websiteURL: "https://petras-iot.org/project/trust-and-privacy-as-design-principles-for-iot-infrastructures-depriot/")
        openWebsiteIfNodeTapped(imageName: "dtcemOrange.png", websiteURL: "https://petras-iot.org/project/digital-twins-in-cyber-effects-modelling-of-iot-cps-points-of-low-resilience-dtcem/")
        openWebsiteIfNodeTapped(imageName: "ebis+Pink.png", websiteURL: "https://petras-iot.org/project/ebis-extending-bim-level-2-to-support-iot-security-demonstrator/")
        openWebsiteIfNodeTapped(imageName: "elliottPink.png", websiteURL: "https://petras-iot.org/project/early-anomaly-detection-for-securing-iot-in-industrial-automation-elliott/")
        openWebsiteIfNodeTapped(imageName: "erGreen.png", websiteURL: "https://petras-iot.org/project/edge-of-reality-er/")
        openWebsiteIfNodeTapped(imageName: "etGreen.png", websiteURL: "https://petras-iot.org/project/edge-of-tomorrow-understanding-the-impacts-of-iot-cybersecurity-and-datafication-to-co-design-a-sustainable-edge-et/")
        openWebsiteIfNodeTapped(imageName: "evaluateGreen.png", websiteURL: "https://petras-iot.org/project/new-forms-of-public-value-at-the-edge-designing-for-hdi-and-trust-in-media-iot-futures-evaluate/")
        openWebsiteIfNodeTapped(imageName: "eviotPink.png", websiteURL: "https://petras-iot.org/project/economic-value-of-iot-data-in-cyberphysical-supply-chains-eviot/")
        openWebsiteIfNodeTapped(imageName: "exiotGreen.png", websiteURL: "https://petras-iot.org/project/experimental-iot-explorations-in-sound-art-and-technology-exiot/")
        openWebsiteIfNodeTapped(imageName: "farmPurple.png", websiteURL: "https://petras-iot.org/project/formal-methods-for-agritech-resilience-modelling-farm/")
        openWebsiteIfNodeTapped(imageName: "fireOrange.png", websiteURL: "https://petras-iot.org/project/future-infrastructure-for-retail-remittances-fire/")
        openWebsiteIfNodeTapped(imageName: "g-iotGreen.png", websiteURL: "https://petras-iot.org/project/gender-the-iot/")
        openWebsiteIfNodeTapped(imageName: "geosecYellow.png", websiteURL: "https://petras-iot.org/project/lightweight-security-and-privacy-for-geographic-personal-data-and-location-based-services-geosec/")
        openWebsiteIfNodeTapped(imageName: "gistOrange.png", websiteURL: "https://petras-iot.org/project/geopolitics-of-iiot-standards-gist/")
        openWebsiteIfNodeTapped(imageName: "graphsecOrange.png", websiteURL: "https://petras-iot.org/project/physical-graph-based-wireless-iot-security-with-no-key-exchange-graphsec/")
        openWebsiteIfNodeTapped(imageName: "health-iOrange.png", websiteURL: "https://petras-iot.org/project/health-i-hybrid-engagement-architecture-layer-for-trusted-human-centric-iot/")
        openWebsiteIfNodeTapped(imageName: "hipsterBlue.png", websiteURL: "https://petras-iot.org/project/health-iot-privacy-and-security-transferred-to-engineering-requirements-hipster/")
        openWebsiteIfNodeTapped(imageName: "iamPink.png", websiteURL: "https://petras-iot.org/project/impact-assessment-model-for-the-iot-iam/")
        openWebsiteIfNodeTapped(imageName: "ice-aiGreen.png", websiteURL: "https://petras-iot.org/project/intelligible-cloud-and-edge-ai-ice-ai/")
        openWebsiteIfNodeTapped(imageName: "ice-odsPink.png", websiteURL: "https://petras-iot.org/project/integrity-checking-at-the-edge-ice-for-operational-decision-support-ice-ods/")
        openWebsiteIfNodeTapped(imageName: "icecOrange.png", websiteURL: "https://petras-iot.org/project/integrated-cyber-secure-edge-computing-icec/")
        openWebsiteIfNodeTapped(imageName: "idiceGreen.png", websiteURL: "https://petras-iot.org/project/making-the-invisible-visible-secure-trustworthy-iot-displays-and-sensors-for-urban-environments-in-cityverve-idice/")
        openWebsiteIfNodeTapped(imageName: "iot-dependsPink.png", websiteURL: "https://petras-iot.org/project/identifying-attack-vectors-for-network-intrusion-to-determine-impact-across-threat-surfaces-iot-depends/")
        openWebsiteIfNodeTapped(imageName: "iotincontrolOrange.png", websiteURL: "https://petras-iot.org/project/iot-in-control/")
        openWebsiteIfNodeTapped(imageName: "iotinparkGreen.png", websiteURL: "https://petras-iot.org/project/iot-in-the-park/")
        openWebsiteIfNodeTapped(imageName: "iotmspOrange.png", websiteURL: "https://petras-iot.org/project/iot-multi-disciplinary-standards-platform-iotmsp/")
        openWebsiteIfNodeTapped(imageName: "iotobservatoryOrange.png", websiteURL: "https://petras-iot.org/project/iot-observatory/")
        openWebsiteIfNodeTapped(imageName: "iototGreen.png", websiteURL: "https://petras-iot.org/project/iot-of-trees-iotot/")
        openWebsiteIfNodeTapped(imageName: "isctiesPink.png", websiteURL: "https://petras-iot.org/project/improving-the-security-of-centralised-transport-infrastructure-efficiency-system-iscties/")
        openWebsiteIfNodeTapped(imageName: "logistics40Pink.png", websiteURL: "https://petras-iot.org/project/logistics-4-0-securing-high-value-goods-using-self-protecting-edge-compute/")
        openWebsiteIfNodeTapped(imageName: "macsGreen.png", websiteURL: "https://petras-iot.org/project/markets-for-connected-space-sharing-macs/")
        openWebsiteIfNodeTapped(imageName: "magicYellow.png", websiteURL: "https://petras-iot.org/project/multi-perspective-design-of-iot-cybersecurity-in-ground-and-aerial-vehicles/")
        openWebsiteIfNodeTapped(imageName: "maiseYellow.png", websiteURL: "https://petras-iot.org/project/multimodal-ai-based-security-at-the-edge-maise/")
        openWebsiteIfNodeTapped(imageName: "massPink.png", websiteURL: "https://petras-iot.org/project/modelling-for-socio-technical-security-mass%e2%80%af/")
        openWebsiteIfNodeTapped(imageName: "nipcOrange.png", websiteURL: "https://petras-iot.org/project/national-and-international-policy-for-critical-infrastructure-cybersecurity-nipc/")
        openWebsiteIfNodeTapped(imageName: "nusbiotPink.png", websiteURL: "https://petras-iot.org/project/newcastle-urban-sciences-building-iot-nusbiot/")
        openWebsiteIfNodeTapped(imageName: "p-carsYellow.png", websiteURL: "https://petras-iot.org/project/privacy-and-trust-in-connected-autonomous-cars-and-smart-transport-peiesi/")
        openWebsiteIfNodeTapped(imageName: "p-piteeGreen.png", websiteURL: "https://petras-iot.org/project/participatory-policies-for-iot-at-the-edge-ethics-p-pitee/")
        openWebsiteIfNodeTapped(imageName: "p2p-ioetOrange.png", websiteURL: "https://petras-iot.org/project/the-internet-of-energy-things-p2p-ioet/")
        openWebsiteIfNodeTapped(imageName: "peiesiBlue.png", websiteURL: "https://petras-iot.org/project/privacy-enhancing-and-identification-enabling-iot-solutions-peiesi/")
        openWebsiteIfNodeTapped(imageName: "petras-dsfOrange.png", websiteURL: "https://petras-iot.org/project/the-petras-data-sharing-foundation-building-a-trustworthy-data-sharing-ecology-for-iot-data-assets-petras-dsf/")
        openWebsiteIfNodeTapped(imageName: "power-sprintPink.png", websiteURL: "https://petras-iot.org/project/power-grid-iot-system-protection-and-resilience-using-intelligent-edge-power-sprint/")
        openWebsiteIfNodeTapped(imageName: "power2Orange.png", websiteURL: "https://petras-iot.org/project/understanding-disruptive-powers-of-iot-in-the-energy-sector-power2/")
        openWebsiteIfNodeTapped(imageName: "ppiemGreen.png", websiteURL: "https://petras-iot.org/project/privacy-preserving-indoor-environment-monitoring-ppiem/")
        openWebsiteIfNodeTapped(imageName: "prioteOrange.png", websiteURL: "https://petras-iot.org/project/positional-referencing-for-iot-at-the-edge-priote/")
        openWebsiteIfNodeTapped(imageName: "prismBlue.png", websiteURL: "https://petras-iot.org/project/privacy-preserving-iot-security-management-prism/")
        openWebsiteIfNodeTapped(imageName: "pristineBlue.png", websiteURL: "https://petras-iot.org/project/privacy-preserving-data-sharing-and-trading-ecosystem-for-distributed-wireless-iot-networks-pristine/")
        openWebsiteIfNodeTapped(imageName: "priviotGreen.png", websiteURL: "https://petras-iot.org/project/understanding-and-mitigating-privacy-risks-of-iot-homes-with-demand-side-management-priviot/")
        openWebsiteIfNodeTapped(imageName: "pswarmsPink.png", websiteURL: "https://petras-iot.org/project/processes-for-securing-for-water-resource-management-systems-pswarms/")
        openWebsiteIfNodeTapped(imageName: "pt-heatGreen.png", websiteURL: "https://petras-iot.org/project/preventing-thermal-attacks-pt-heat/")
        openWebsiteIfNodeTapped(imageName: "pubviaGreen.png", websiteURL: "https://petras-iot.org/project/building-public-value-via-intelligible-ai-pubvia/")
        openWebsiteIfNodeTapped(imageName: "raceGreen.png", websiteURL: "https://petras-iot.org/project/responding-to-attacks-and-compromise-at-the-edge-race/")
        openWebsiteIfNodeTapped(imageName: "reappearGreen.png", websiteURL: "https://petras-iot.org/project/the-reappearing-computer-foregrounding-privacy-in-iot-reappear/")
        openWebsiteIfNodeTapped(imageName: "recopsGreen.png", websiteURL: "https://petras-iot.org/project/resolving-conflicts-in-public-spaces-recops/")
        openWebsiteIfNodeTapped(imageName: "red-aidBlue.png", websiteURL: "https://petras-iot.org/project/red-aid-respectful-and-capability-centred-ai-device-for-preventing-call-fraud/")
        openWebsiteIfNodeTapped(imageName: "reg-medtechBlue.png", websiteURL: "https://petras-iot.org/project/regulatory-and-standardization-challenges-for-connected-and-intelligent-medical-devices-reg-medtech/")
        openWebsiteIfNodeTapped(imageName: "resbeGreen.png", websiteURL: "https://petras-iot.org/project/resilient-built-environments-resbe/")
        openWebsiteIfNodeTapped(imageName: "retconOrange.png", websiteURL: "https://petras-iot.org/project/red-teaming-the-connected-world-retcon/")
        openWebsiteIfNodeTapped(imageName: "retipsGreen.png", websiteURL: "https://petras-iot.org/project/respectful-things-in-private-spaces-retips/")
        openWebsiteIfNodeTapped(imageName: "rioteOrange.png", websiteURL: "https://petras-iot.org/project/resilient-iot-on-the-edge-riote/")
        openWebsiteIfNodeTapped(imageName: "roadmappYellow.png", websiteURL: "https://petras-iot.org/project/roadmapp/")
        openWebsiteIfNodeTapped(imageName: "roast-iotOrange.png", websiteURL: "https://petras-iot.org/project/robustness-as-traceability-secure-and-legal-calibration-workflows-in-iot-roast-iot/")
        openWebsiteIfNodeTapped(imageName: "rsiotOrange.png", websiteURL: "https://petras-iot.org/project/resilience-and-security-in-low-power-iot-rsiot/")
        openWebsiteIfNodeTapped(imageName: "sdriotss-2Orange.png", websiteURL: "https://petras-iot.org/project/sdriotss-2/")
        openWebsiteIfNodeTapped(imageName: "sdriotssOrange.png", websiteURL: "https://petras-iot.org/project/software-defined-receiver-iot-spectrum-survey-sdriotss/")
        openWebsiteIfNodeTapped(imageName: "sec-qbsPink.png", websiteURL: "https://petras-iot.org/project/security-query-based-systems-sec-qbs/")
        openWebsiteIfNodeTapped(imageName: "secrisOrange.png", websiteURL: "https://petras-iot.org/project/security-risk-assessment-of-iot-environments-with-attack-graph-models-secris/")
        openWebsiteIfNodeTapped(imageName: "semiotGreen.png", websiteURL: "https://petras-iot.org/project/securing-the-value-of-smart-metering-semiot/")
        openWebsiteIfNodeTapped(imageName: "senth+Blue.png", websiteURL: "https://petras-iot.org/project/iot-security-for-health-care-senth/")
        openWebsiteIfNodeTapped(imageName: "senthBlue.png", websiteURL: "https://petras-iot.org/project/security-and-new-threats-in-healthcare-senth/")
        openWebsiteIfNodeTapped(imageName: "sofiotsPink.png", websiteURL: "https://petras-iot.org/project/secure-ontologies-for-iot-systems-sofiots/")
        openWebsiteIfNodeTapped(imageName: "spiotshOrange.png", websiteURL: "https://petras-iot.org/project/security-and-performance-in-the-iot-smart-home-spiotsh/")
        openWebsiteIfNodeTapped(imageName: "spiseGreen.png", websiteURL: "https://petras-iot.org/project/secure-payments-in-smart-environments-spise/")
        openWebsiteIfNodeTapped(imageName: "stipsGreen.png", websiteURL: "https://petras-iot.org/project/smart-transactions-in-public-spaces-stips/")
        openWebsiteIfNodeTapped(imageName: "tansecOrange.png", websiteURL: "https://petras-iot.org/project/tangible-security-tansec/")
        openWebsiteIfNodeTapped(imageName: "teamGreen.png", websiteURL: "https://petras-iot.org/project/evaluating-trustworthiness-of-edge-based-multi-tenanted-iot-devices-team/")
        openWebsiteIfNodeTapped(imageName: "thingsd-artGreen.png", websiteURL: "https://petras-iot.org/project/evaluation-of-iot-systems-requirements-for-tracking-applications-things-dart/")
        openWebsiteIfNodeTapped(imageName: "tmdaYellow.png", websiteURL: "https://petras-iot.org/project/transport-and-mobility-demonstrator-audit-tmda/")
        openWebsiteIfNodeTapped(imageName: "tomsacYellow.png", websiteURL: "https://petras-iot.org/project/trade-off-management-between-safety-and-cybersecurity-tomsac/")
        openWebsiteIfNodeTapped(imageName: "trusdedOrange.png", websiteURL: "https://petras-iot.org/project/trustworthy-software-defined-cyberattack-detection-and-mitigation-at-the-network-edge-trusded/")
        openWebsiteIfNodeTapped(imageName: "udaiotGreen.png", websiteURL: "https://petras-iot.org/project/user-centric-design-for-adoption-of-iot-udaiot/")
        openWebsiteIfNodeTapped(imageName: "umisYellow.png", websiteURL: "https://petras-iot.org/project/increasing-user-trust-in-mobility-as-a-service-iot-ecosystem-umis/")
        openWebsiteIfNodeTapped(imageName: "uncanaiOrange.png", websiteURL: "https://petras-iot.org/project/uncanny-ai-uncanai/")
        // Define a data structure to track added image nodes for each anchor
        func dToR(_ degrees: Float) -> Float {
            return degrees * Float.pi / 180.0
        }
        var addedImageNodes: [String: Set<String>] = [:]

        func handleBoxTap(hitNodeName: String, tapStatus: inout Bool, anchorImagePairs: [(anchorName: String, imageName: String)]) {
            tapStatus = !tapStatus
            let action = tapStatus ? "tapped" : "untapped"
            print("\(action) \(hitNodeName) box.")
            
            for (anchorName, imageName) in anchorImagePairs {
                guard let anchorNode = anchorNodes.first(where: { $0.key.name == anchorName })?.value else {
                    continue
                }
                let addedNodesForAnchor = addedImageNodes[anchorName, default: Set()]
                let imageNodesToRemove = anchorNode.childNodes.filter { $0.name == imageName }
                if tapStatus {
                    let randomDuration = CGFloat.random(in: 1.0...2.0)
                    if !addedNodesForAnchor.contains(imageName) && !imageName.isEmpty {
                        if imageName == "umisYellow.png" {
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-72) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "costcmorsYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(25) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "raceGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "retconOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "cedeOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "gistOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "sdriotss-2Orange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "roast-iotOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "petras-dsfOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(90) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "sec-qbsPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(35) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "spiotshOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-25) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        }  else if imageName == "costcmorsYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(25) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "cyfooPurple.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(0) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "g-iotGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-15) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "iototGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-85) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "iamPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-55) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "elliottPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-35) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "cyferBlue.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(35) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "pristineBlue.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(35) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "hipsterBlue.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(35) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "red-aidBlue.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-55) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "cratePink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-55) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "ppiemGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-55) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            
                        } else if imageName == "aikemaYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-65) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "trusdedOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-68) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "pt-heatGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-52) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "spiseGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-72) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "erGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-80) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "pswarmsPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-74) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "fireOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-72) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "uncanaiOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-82) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "isctiesPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-85) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "rioteOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-67) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "massPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-67) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "blataOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(-67) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "prismBlue.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(15) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "digiportPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(65) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "priviotGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(20) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "resbeGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(70) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "pubviaGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(70) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "reappearGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(70) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "costcmorsYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(80) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "tomsacYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(80) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "amloeYellow.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(80) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "graphsecOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(77) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "sofiotsPink.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(77) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "icecOrange.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(77) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else if imageName == "etGreen.png"{
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: dToR(15) , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                        } else {
                            addImageNode(imageName: imageName, identifier: imageName, duration: randomDuration,rotationAngleRadians: 0 , toNode: anchorNode)
                            addedImageNodes[anchorName, default: Set()].insert(imageName)
                            print(imageName)
                        }
                    }
                    
                } else {
                    for imageNode in imageNodesToRemove {
                        imageNode.removeFromParentNode()
                        addedImageNodes[anchorName]?.remove(imageName)
                    }
                }
            }
        }
        let defaultNodeName = "SomeDefaultValue"

        if hitNodeName == "Box005_09___Green_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("resbeAnchor", "resbeGreen.png"),
                ("ariotAnchor", "ariotGreen.png"),
                ("depriotAnchor", "depriotGreen.png"),
                ("disscAnchor", "disscGreen.png"),
                ("erAnchor", "erGreen.png"),
                ("etAnchor", "etGreen.png"),
                ("evaluateAnchor", "evaluateGreen.png"),
                ("exiotAnchor", "exiotGreen.png"),
                ("giotAnchor", "g-iotGreen.png"),
                ("iceaiAnchor", "ice-aiGreen.png"),
                ("idiceAnchor", "idiceGreen.png"),
                ("iotinparkAnchor", "iotinparkGreen.png"),
                ("iototAnchor", "iototGreen.png"),
                ("macsAnchor", "macsGreen.png"),
                ("ppiteeAnchor", "p-piteeGreen.png"),
                ("ppiemAnchor", "ppiemGreen.png"),
                ("priviotAnchor", "priviotGreen.png"),
                ("ptheatAnchor", "pt-heatGreen.png"),
                ("pubviaAnchor", "pubviaGreen.png"),
                ("raceAnchor", "raceGreen.png"),
                ("reappearAnchor", "reappearGreen.png"),
                ("recopsAnchor", "recopsGreen.png"),
                ("retipsAnchor", "retipsGreen.png"),
                ("semiotAnchor", "semiotGreen.png"),
                ("spiseAnchor", "spiseGreen.png"),
                ("stipsAnchor", "stipsGreen.png"),
                ("teamAnchor", "teamGreen.png"),
                ("thingsdartAnchor", "thingsd-artGreen.png"),
                ("udaiotAnchor", "udaiotGreen.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isGreenTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Yellow_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("aikemaAnchor", "aikemaYellow.png"),
                ("amloeAnchor", "amloeYellow.png"),
                ("costcmorsAnchor", "costcmorsYellow.png"),
                ("ddipiotAnchor", "ddip-iotYellow.png"),
                ("geosecAnchor", "geosecYellow.png"),
                ("magicAnchor", "magicYellow.png"),
                ("maiseAnchor", "maiseYellow.png"),
                ("pcarsAnchor", "p-carsYellow.png"),
                ("roadmappAnchor", "roadmappYellow.png"),
                ("tmdaAnchor", "tmdaYellow.png"),
                ("tomsacAnchor", "tomsacYellow.png"),
                ("umisAnchor", "umisYellow.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isYellowTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Purple_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("cyfooAnchor", "cyfooPurple.png"),
                ("farmAnchor", "farmPurple.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isPurpleTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Orange_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("blataAnchor", "blataOrange.png"),
                ("blockitAnchor", "blockitOrange.png"),
                ("botthingsAnchor", "botthingsOrange.png"),
                ("btsAnchor", "btsOrange.png"),
                ("cedeAnchor", "cedeOrange.png"),
                ("cracsAnchor", "cracsOrange.png"),
                ("csiplusAnchor", "csi+Orange.png"),
//                ("csiAnchor", "csiOrange.png"),
                ("cyberhygieneAnchor", "cyberhygieneOrange.png"),
                ("dtcemAnchor", "dtcemOrange.png"),
                ("fireAnchor", "fireOrange.png"),
                ("gistAnchor", "gistOrange.png"),
                ("graphsecAnchor", "graphsecOrange.png"),
                ("healthiAnchor", "health-iOrange.png"),
                ("icecAnchor", "icecOrange.png"),
                ("iotincontrolAnchor", "iotincontrolOrange.png"),
                ("iotmspAnchor", "iotmspOrange.png"),
                ("iotobservatoryAnchor", "iotobservatoryOrange.png"),
                ("nipcAnchor", "nipcOrange.png"),
                ("p2pioetAnchor", "p2p-ioetOrange.png"),
                ("petrasdsfAnchor", "petras-dsfOrange.png"),
                ("power2Anchor", "power2Orange.png"),
                ("prioteAnchor", "prioteOrange.png"),
                ("retconAnchor", "retconOrange.png"),
                ("rioteAnchor", "rioteOrange.png"),
                ("roastiotAnchor", "roast-iotOrange.png"),
                ("rsiotAnchor", "rsiotOrange.png"),
                ("sdriotss2Anchor", "sdriotss-2Orange.png"),
//                ("sdriotssAnchor", "sdriotssOrange.png"),
                ("secrisAnchor", "secrisOrange.png"),
                ("spiotshAnchor", "spiotshOrange.png"),
                ("tansecAnchor", "tansecOrange.png"),
                ("trusdedAnchor", "trusdedOrange.png"),
                ("uncanaiAnchor", "uncanaiOrange.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isOrangeTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Blue_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("aaciotAnchor", "aaciotBlue.png"),
                ("beclAnchor", "beclBlue.png"),
                ("cpsociamAnchor", "cp-sociamBlue.png"),
                ("cyferAnchor", "cyferBlue.png"),
                ("dashAnchor", "dashBlue.png"),
                ("hipsterAnchor", "hipsterBlue.png"),
                ("peiesiAnchor", "peiesiBlue.png"),
                ("prismAnchor", "prismBlue.png"),
                ("pristineAnchor", "pristineBlue.png"),
                ("redaidAnchor", "red-aidBlue.png"),
                ("regmedtechAnchor", "reg-medtechBlue.png"),
                ("senthplusAnchor", "senth+Blue.png"),
//                ("senthAnchor", "senthBlue.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isBlueTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Pink_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("crateAnchor", "cratePink.png"),
                ("digiportAnchor", "digiportPink.png"),
                ("ebisplusAnchor", "ebis+Pink.png"),
                ("elliottAnchor", "elliottPink.png"),
                ("eviotAnchor", "eviotPink.png"),
                ("iamAnchor", "iamPink.png"),
                ("iceodsAnchor", "ice-odsPink.png"),
                ("iotdependsAnchor", "iot-dependsPink.png"),
                ("isctiesAnchor", "isctiesPink.png"),
                ("logistics40Anchor", "logistics40Pink.png"),
                ("massAnchor", "massPink.png"),
                ("nusbiotAnchor", "nusbiotPink.png"),
                ("powersprintAnchor", "power-sprintPink.png"),
                ("pswarmsAnchor", "pswarmsPink.png"),
                ("secqbsAnchor", "sec-qbsPink.png"),
                ("sofiotsAnchor", "sofiotsPink.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isPinkTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___Black_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("resbeAnchor", "resbeGreen.png"),
                ("ariotAnchor", "ariotGreen.png"),
                ("depriotAnchor", "depriotGreen.png"),
                ("disscAnchor", "disscGreen.png"),
                ("erAnchor", "erGreen.png"),
                ("etAnchor", "etGreen.png"),
                ("evaluateAnchor", "evaluateGreen.png"),
                ("exiotAnchor", "exiotGreen.png"),
                ("giotAnchor", "g-iotGreen.png"),
                ("iceaiAnchor", "ice-aiGreen.png"),
                ("idiceAnchor", "idiceGreen.png"),
                ("iotinparkAnchor", "iotinparkGreen.png"),
                ("iototAnchor", "iototGreen.png"),
                ("macsAnchor", "macsGreen.png"),
                ("ppiteeAnchor", "p-piteeGreen.png"),
                ("ppiemAnchor", "ppiemGreen.png"),
                ("priviotAnchor", "priviotGreen.png"),
                ("ptheatAnchor", "pt-heatGreen.png"),
                ("pubviaAnchor", "pubviaGreen.png"),
                ("raceAnchor", "raceGreen.png"),
                ("reappearAnchor", "reappearGreen.png"),
                ("recopsAnchor", "recopsGreen.png"),
                ("retipsAnchor", "retipsGreen.png"),
                ("semiotAnchor", "semiotGreen.png"),
                ("spiseAnchor", "spiseGreen.png"),
                ("stipsAnchor", "stipsGreen.png"),
                ("teamAnchor", "teamGreen.png"),
                ("thingsdartAnchor", "thingsd-artGreen.png"),
                ("udaiotAnchor", "udaiotGreen.png"),
                ("aikemaAnchor", "aikemaYellow.png"),
                ("amloeAnchor", "amloeYellow.png"),
                ("costcmorsAnchor", "costcmorsYellow.png"),
                ("ddipiotAnchor", "ddip-iotYellow.png"),
                ("geosecAnchor", "geosecYellow.png"),
                ("magicAnchor", "magicYellow.png"),
                ("maiseAnchor", "maiseYellow.png"),
                ("pcarsAnchor", "p-carsYellow.png"),
                ("roadmappAnchor", "roadmappYellow.png"),
                ("tmdaAnchor", "tmdaYellow.png"),
                ("tomsacAnchor", "tomsacYellow.png"),
                ("umisAnchor", "umisYellow.png"),
                ("cyfooAnchor", "cyfooPurple.png"),
                ("farmAnchor", "farmPurple.png"),
                ("blataAnchor", "blataOrange.png"),
                ("blockitAnchor", "blockitOrange.png"),
                ("botthingsAnchor", "botthingsOrange.png"),
                ("btsAnchor", "btsOrange.png"),
                ("cedeAnchor", "cedeOrange.png"),
                ("cracsAnchor", "cracsOrange.png"),
                ("csiplusAnchor", "csi+Orange.png"),
//                ("csiAnchor", "csiOrange.png"),
                ("cyberhygieneAnchor", "cyberhygieneOrange.png"),
                ("dtcemAnchor", "dtcemOrange.png"),
                ("fireAnchor", "fireOrange.png"),
                ("gistAnchor", "gistOrange.png"),
                ("graphsecAnchor", "graphsecOrange.png"),
                ("healthiAnchor", "health-iOrange.png"),
                ("icecAnchor", "icecOrange.png"),
                ("iotincontrolAnchor", "iotincontrolOrange.png"),
                ("iotmspAnchor", "iotmspOrange.png"),
                ("iotobservatoryAnchor", "iotobservatoryOrange.png"),
                ("nipcAnchor", "nipcOrange.png"),
                ("p2pioetAnchor", "p2p-ioetOrange.png"),
                ("petrasdsfAnchor", "petras-dsfOrange.png"),
                ("power2Anchor", "power2Orange.png"),
                ("prioteAnchor", "prioteOrange.png"),
                ("retconAnchor", "retconOrange.png"),
                ("rioteAnchor", "rioteOrange.png"),
                ("roastiotAnchor", "roast-iotOrange.png"),
                ("rsiotAnchor", "rsiotOrange.png"),
                ("sdriotss2Anchor", "sdriotss-2Orange.png"),
//                ("sdriotssAnchor", "sdriotssOrange.png"),
                ("secrisAnchor", "secrisOrange.png"),
                ("spiotshAnchor", "spiotshOrange.png"),
                ("tansecAnchor", "tansecOrange.png"),
                ("trusdedAnchor", "trusdedOrange.png"),
                ("uncanaiAnchor", "uncanaiOrange.png"),
                ("aaciotAnchor", "aaciotBlue.png"),
                ("beclAnchor", "beclBlue.png"),
                ("cpsociamAnchor", "cp-sociamBlue.png"),
                ("cyferAnchor", "cyferBlue.png"),
                ("dashAnchor", "dashBlue.png"),
                ("hipsterAnchor", "hipsterBlue.png"),
                ("peiesiAnchor", "peiesiBlue.png"),
                ("prismAnchor", "prismBlue.png"),
                ("pristineAnchor", "pristineBlue.png"),
                ("redaidAnchor", "red-aidBlue.png"),
                ("regmedtechAnchor", "reg-medtechBlue.png"),
                ("senthplusAnchor", "senth+Blue.png"),
//                ("senthAnchor", "senthBlue.png"),
                ("crateAnchor", "cratePink.png"),
                ("digiportAnchor", "digiportPink.png"),
                ("ebisplusAnchor", "ebis+Pink.png"),
                ("elliottAnchor", "elliottPink.png"),
                ("eviotAnchor", "eviotPink.png"),
                ("iamAnchor", "iamPink.png"),
                ("iceodsAnchor", "ice-odsPink.png"),
                ("iotdependsAnchor", "iot-dependsPink.png"),
                ("isctiesAnchor", "isctiesPink.png"),
                ("logistics40Anchor", "logistics40Pink.png"),
                ("massAnchor", "massPink.png"),
                ("nusbiotAnchor", "nusbiotPink.png"),
                ("powersprintAnchor", "power-sprintPink.png"),
                ("pswarmsAnchor", "pswarmsPink.png"),
                ("secqbsAnchor", "sec-qbsPink.png"),
                ("sofiotsAnchor", "sofiotsPink.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isBlackTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___BlackHUB_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("recopsAnchor", "recopsGreen.png"),
                ("iamAnchor", "iamPink.png"),
                ("iotdependsAnchor", "iot-dependsPink.png"),
                ("nusbiotAnchor", "nusbiotPink.png"),
                ("blockitAnchor", "blockitOrange.png"),
                ("botthingsAnchor", "botthingsOrange.png"),
                ("cracsAnchor", "cracsOrange.png"),
                ("iotincontrolAnchor", "iotincontrolOrange.png"),
                ("rsiotAnchor", "rsiotOrange.png"),
                ("secrisAnchor", "secrisOrange.png"),
                ("spiotshAnchor", "spiotshOrange.png"),
                ("aaciotAnchor", "aaciotBlue.png"),
                ("senthplusAnchor", "senth+Blue.png"),
//                ("senthAnchor", "senthBlue.png"),
                ("geosecAnchor", "geosecYellow.png"),
                ("ariotAnchor", "ariotGreen.png"),
                ("iototAnchor", "iototGreen.png"),
                ("idiceAnchor", "idiceGreen.png"),
                ("depriotAnchor", "depriotGreen.png"),
                ("iotinparkAnchor", "iotinparkGreen.png"),
                ("disscAnchor", "disscGreen.png"),
                ("retipsAnchor", "retipsGreen.png"),
                ("stipsAnchor", "stipsGreen.png"),
                ("cyberhygieneAnchor", "cyberhygieneOrange.png"),
                ("healthiAnchor", "health-iOrange.png"),
                ("iotobservatoryAnchor", "iotobservatoryOrange.png"),
                ("dashAnchor", "dashBlue.png"),
                ("peiesiAnchor", "peiesiBlue.png"),
                ("pcarsAnchor", "p-carsYellow.png"),
                ("thingsdartAnchor", "thingsd-artGreen.png"),
                ("giotAnchor", "g-iotGreen.png"),
                ("ebisplusAnchor", "ebis+Pink.png"),
                ("csiplusAnchor", "csi+Orange.png"),
//                ("csiAnchor", "csiOrange.png"),
                ("iotmspAnchor", "iotmspOrange.png"),
                ("nipcAnchor", "nipcOrange.png"),
                ("tmdaAnchor", "tmdaYellow.png"),
                ("semiotAnchor", "semiotGreen.png"),
                ("eviotAnchor", "eviotPink.png"),
                ("btsAnchor", "btsOrange.png"),
                ("p2pioetAnchor", "p2p-ioetOrange.png"),
                ("roadmappAnchor", "roadmappYellow.png"),
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isBlackHubTapped, anchorImagePairs: anchorImagePairs)
        }
        if hitNodeName == "Box005_09___BlackCENTRE_0" {
            let anchorImagePairs: [(anchorName: String, imageName: String)] = [
                ("exiotAnchor", "exiotGreen.png"), // k
                ("raceAnchor", "raceGreen.png"), // tray
                ("resbeAnchor", "resbeGreen.png"), // k
                ("spiseAnchor", "spiseGreen.png"), // k
                ("ptheatAnchor", "pt-heatGreen.png"), // k
                ("teamAnchor", "teamGreen.png"), // k
                ("crateAnchor", "cratePink.png"), // k
                ("digiportAnchor", "digiportPink.png"), // k
                ("elliottAnchor", "elliottPink.png"), // k
                ("iceodsAnchor", "ice-odsPink.png"), // k
                ("isctiesAnchor", "isctiesPink.png"), // k
                ("massAnchor", "massPink.png"), // k
                ("powersprintAnchor", "power-sprintPink.png"), // k
                ("pswarmsAnchor", "pswarmsPink.png"), // k
                ("sofiotsAnchor", "sofiotsPink.png"), // k
                ("dtcemAnchor", "dtcemOrange.png"), // k
                ("icecAnchor", "icecOrange.png"), // k
                ("prioteAnchor", "prioteOrange.png"),
                ("retconAnchor", "retconOrange.png"), // tray
                ("rioteAnchor", "rioteOrange.png"), // k
                ("trusdedAnchor", "trusdedOrange.png"), // k
                ("cyferAnchor", "cyferBlue.png"), // k
                ("hipsterAnchor", "hipsterBlue.png"), // k
                ("prismAnchor", "prismBlue.png"), // k
                ("redaidAnchor", "red-aidBlue.png"), // k
                ("cyfooAnchor", "cyfooPurple.png"), // k
                ("amloeAnchor", "amloeYellow.png"), // k
                ("costcmorsAnchor", "costcmorsYellow.png"), // k
                ("maiseAnchor", "maiseYellow.png"), // k
                ("magicAnchor", "magicYellow.png"), // k
                ("tomsacAnchor", "tomsacYellow.png"), // k
                ("evaluateAnchor", "evaluateGreen.png"), // k
                ("reappearAnchor", "reappearGreen.png"), // k
                ("iceaiAnchor", "ice-aiGreen.png"), // k
                ("cedeAnchor", "cedeOrange.png"), // tray
                ("graphsecAnchor", "graphsecOrange.png"), // k
                ("sdriotss2Anchor", "sdriotss-2Orange.png"), // tray
////                ("sdriotssAnchor", "sdriotssOrange.png"),
                ("tansecAnchor", "tansecOrange.png"), // k
                ("uncanaiAnchor", "uncanaiOrange.png"), // k
                ("pristineAnchor", "pristineBlue.png"), // k
                ("farmAnchor", "farmPurple.png"), // k
                ("macsAnchor", "macsGreen.png"), // k
                ("logistics40Anchor", "logistics40Pink.png"), // k
                ("blataAnchor", "blataOrange.png"), // k
                ("gistAnchor", "gistOrange.png"), // tray
                ("petrasdsfAnchor", "petras-dsfOrange.png"), // tray
                ("power2Anchor", "power2Orange.png"), // k
                ("roastiotAnchor", "roast-iotOrange.png"), // tray
                ("beclAnchor", "beclBlue.png"), // k
                ("regmedtechAnchor", "reg-medtechBlue.png"), // k
                ("umisAnchor", "umisYellow.png"), // k
                ("erAnchor", "erGreen.png"), // k
                ("etAnchor", "etGreen.png"), // k
                ("ppiemAnchor", "ppiemGreen.png"), // k
                ("priviotAnchor", "priviotGreen.png"), // k
                ("ppiteeAnchor", "p-piteeGreen.png"), // k
                ("pubviaAnchor", "pubviaGreen.png"), // k
                ("secqbsAnchor", "sec-qbsPink.png"), // k
                ("fireAnchor", "fireOrange.png"), // k
                ("cpsociamAnchor", "cp-sociamBlue.png"), // k
                ("aikemaAnchor", "aikemaYellow.png"),// k
            ]
            handleBoxTap(hitNodeName: hitNodeName ?? defaultNodeName, tapStatus: &isBlackCentreTapped, anchorImagePairs: anchorImagePairs)
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        func addFloatingBox(to anchor: ARAnchor, with resourceName: String, animationDuration: TimeInterval) {
            guard let boxUrl = Bundle.main.url(forResource: resourceName, withExtension: "usdz"),
                  let boxNode = SCNReferenceNode(url: boxUrl) else {
                fatalError("Failed to find \(resourceName).usdz in the bundle.")
            }
            print(resourceName)
            
            // Check if the resource name is "shelf" or not
            if resourceName == "shelf" {
                print("Shelf found")
                // Apply a different scale for "shelf"
                boxNode.scale = SCNVector3(1, 1, 1)
                boxNode.eulerAngles = SCNVector3(0, Float.pi/2, Float.pi/2)
            } else {
                // Apply a different scale for other objects
                // Rotate, scale.
                boxNode.eulerAngles = SCNVector3(0, Float.pi, Float.pi)
                boxNode.scale = SCNVector3(0.0008, 0.0008, 0.0008) // Adjust the scale as needed
            }
            boxNode.load()
            
            // Add the box node as a child of the anchor's node
            node.addChildNode(boxNode)
            
            // Create a floating animation
            let floatUpAction = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: animationDuration)
            floatUpAction.timingMode = .easeInEaseOut
            let floatDownAction = floatUpAction.reversed()
            let floatActionSequence = SCNAction.sequence([floatUpAction, floatDownAction])
            let floatActionLoop = SCNAction.repeatForever(floatActionSequence)
            
             //Apply the floating animation to the box
             boxNode.runAction(floatActionLoop)
        }
        anchors.append(anchor)
        anchorNodes[anchor] = node
        // let rotationAngle = Float.pi / 2.0 // 90 degrees in radians
        if anchor.name == "blueAnchor" {
            addFloatingBox(to: anchor, with: "blueBoxTextRotated", animationDuration: 1.5)
        }
        if anchor.name == "pinkAnchor" {
            addFloatingBox(to: anchor, with: "pinkBoxTextRotated", animationDuration: 1.4)
        }
        if anchor.name == "yellowAnchor" {
            addFloatingBox(to: anchor, with: "yellowBoxTextRotated", animationDuration: 1.3)
        }
        if anchor.name == "orangeAnchor" {
            addFloatingBox(to: anchor, with: "orangeBoxTextRotated", animationDuration: 1.2)
        }
        if anchor.name == "purpleAnchor" {
            addFloatingBox(to: anchor, with: "purpleBoxTextRotated", animationDuration: 1.1)
        }
        if anchor.name == "greenAnchor" {
            addFloatingBox(to: anchor, with: "greenBoxTextRotated", animationDuration: 1.0)
        }
        if anchor.name == "blackAnchor" {
            addFloatingBox(to: anchor, with: "blackBoxTextRotated", animationDuration: 1.6)
        }
        if anchor.name == "blackAnchorHub" {
            addFloatingBox(to: anchor, with: "blackBoxTextRotatedHub", animationDuration: 1.41)
        }
        if anchor.name == "blackAnchorCentre" {
            addFloatingBox(to: anchor, with: "blackBoxTextRotatedCentre", animationDuration: 1.25)
        }
        if anchor.name == "shelfAnchor" {
            addFloatingBox(to: anchor, with: "shelf", animationDuration: 1.8e308)
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
