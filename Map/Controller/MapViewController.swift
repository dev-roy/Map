//
//  ViewController.swift
//  Map
//
//  Created by Rodrigo Buendia Ramos on 4/26/20.
//  Copyright © 2020 Rodrigo Buendia Ramos. All rights reserved.
//

import UIKit
import PullUpController
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
     // MARK: - Properties
    private let visualEffectView = UIVisualEffectView(effect: nil)
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var searchViewController: SearchViewController!
    private var originalPullUpControllerViewSize: CGSize = .zero
    private var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        setUpVisualBlurEffectView()
        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        addPullUpController(animated: true)
    }
    
    // MARK: - Init
    private func addPullUpController(animated: Bool) {
        let pullUpController = makeSearchViewControllerIfNeeded()
        _ = pullUpController.view
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
    
    private func makeSearchViewControllerIfNeeded() -> SearchViewController {
        let currentPullUpController = children
            .filter({ $0 is SearchViewController })
            .first as? SearchViewController
        let pullUpController: SearchViewController = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        pullUpController.delegate = self
        if originalPullUpControllerViewSize == .zero {
            originalPullUpControllerViewSize = pullUpController.view.bounds.size
        }
        return pullUpController
    }
    
    private func setUpVisualBlurEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.frame = view.frame
        visualEffectView.isUserInteractionEnabled = false
    }
    
    // MARK: - Handlers
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    
    private func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Some Title"
            annotation.subtitle = "Some Subtitle"
            self.mapView.addAnnotation(annotation)
    }
    
    func zoom(to location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func pullUpControllerValueChanged(height: CGFloat) {
        animator.fractionComplete = 516.0
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}

// MARK: - Extensions

// MARK: - MapView methods
extension MapViewController: MKMapViewDelegate {

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        pinView!.pinTintColor = UIColor.black
    } else {
        pinView!.annotation = annotation
    }
    return pinView
}

func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("tapped on pin ")
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
        if let doSomething = view.annotation?.title! {
           print("do something")
        }
    }
  }
}

// MARK: CoreLocation Methods
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinates: CLLocationCoordinate2D = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        zoom(to: coordinates)
    }
}

extension MapViewController: SearchCountry {
    func search(countryName: String) {
        getCoordinateFrom(address: countryName) { (coordinates, error) in
            switch (coordinates, error) {
            // Obtained coordinates
            case (_, nil):
                let searchVC = self.makeSearchViewControllerIfNeeded()
                self.zoom(to: coordinates!)
                searchVC.pullUpControllerMoveToVisiblePoint(searchVC.initialPointOffset, animated: true, completion: nil)
            // Error
            case (nil, _):
                print(error)
                let ac = UIAlertController(title: "No results found", message: "Your query did not match any results.", preferredStyle: .alert)
                       ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            default:
                break
            }
        }
    }
    

}
