//
//  ARSearchTrailerViewController.swift
//  BoxOffice
//
//  Created by Kim EenSung on 3/13/24.
//

import ARKit
import AVKit
import UIKit

final class ARSearchTrailerViewController: UIViewController, ARSessionDelegate {
    private lazy var session: ARSession = {
        let session = ARSession()
        session.delegate = self
        session.run(configuration)
        return session
    }()
    private let configuration: ARImageTrackingConfiguration = ARImageTrackingConfiguration()
    private var referenceImage: Set<ARReferenceImage> = []
    
    private lazy var trailerSearchView: ARSCNView = {
        let trailerSearchView = ARSCNView()
        trailerSearchView.delegate = self
        return trailerSearchView
    }()
    
    private lazy var avPlayerViewController: AVPlayerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTrailers()
        
        Task {
            await loadImage()
        }
        addGesture()
    }
    
    override func loadView() {
        view = trailerSearchView
        trailerSearchView.session = session
    }
}

extension ARSearchTrailerViewController {
    private func setTrailers() {
        _ = MovieTrailer(
            name: "wall-e",
            image: "https://upload.wikimedia.org/wikipedia/en/thumb/4/4c/WALL-E_poster.jpg/220px-WALL-E_poster.jpg",
            video: "https://drive.google.com/uc?export=download&id=12OS64ap-N_xftUw2GkUYU-okdTzWuR1y"
        )
        _ = MovieTrailer(
            name: "듄2",
            image: "https://upload.wikimedia.org/wikipedia/en/5/52/Dune_Part_Two_poster.jpeg?20240201000109",
            video: "https://drive.google.com/uc?export=download&id=1iOPW1HPorAByCP_g2k7k6KkW0UrPudbu"
        )
        _ = MovieTrailer(
            name: "파묘",
            image: "https://drive.google.com/uc?export=download&id=1RPgw8CDOzGYPrJFNlq-AAUup0rT6Yoi3",
            video: "https://drive.google.com/uc?export=download&id=1USGSNNNJAnq-ZWY_yUksPOwEpsPYxQRZ"
        )
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.trailerSearchView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let location = gestureRecognize.location(in: trailerSearchView)
        let hitResults = trailerSearchView.hitTest(location, options: [:])
        if let firstHit = hitResults.first {
            let node = firstHit.node
            guard let movieName = node.name,
                  let url = MovieTrailer.trailers[movieName]?.video else {
                return
            }
            
            avPlayerViewController.player = AVPlayer(url: url)
            avPlayerViewController.player?.play()
            present(avPlayerViewController, animated: true)
        }
    }
    
    private func loadImage() async {
        for trailer in MovieTrailer.trailers {
            do {
                guard let url = trailer.value.image else { return }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let image = UIImage(data: data)?.cgImage else { return }
                
                let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: 0.2)
                referenceImage.name = trailer.value.name
                self.referenceImage.insert(referenceImage)
                
            } catch {
                print(error)
            }
        }
        
        configuration.trackingImages = referenceImage
        configuration.maximumNumberOfTrackedImages = 3
        session.run(configuration)
    }
}

extension ARSearchTrailerViewController: ARSCNViewDelegate {
    func renderer(_ renderer: any SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            let overlayNode = createOverlayNode(for: imageAnchor.referenceImage)
            node.addChildNode(overlayNode)
        }
    }
    
    private func createOverlayNode(for referenceImage: ARReferenceImage) -> SCNNode {
        let plane: SCNPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        
        let overlayNode = SCNNode(geometry: plane)
        overlayNode.name = referenceImage.name
        overlayNode.eulerAngles.x = -.pi / 2
        overlayNode.opacity = 0.25
        
        return overlayNode
    }
}
