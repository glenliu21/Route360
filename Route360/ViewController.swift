//
//  ViewController.swift
//  Route360
//
//  Created by Glen Liu on 11/29/21.
//

import UIKit
import MapKit

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
     }
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    
        
        let pennypacker = StartPoint(title: "Pennypacker", coordinate: CLLocationCoordinate2D(latitude: 42.37265009033051, longitude: -71.113721461528942), distance: 4.5)

        mapView.addAnnotation(pennypacker)
    }
    
    // This is called when an annotation needs to be shown
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StartPoint else { return nil }
        
        let identifier = "StartPoint"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // Create a new annotation view if one isn't in the queue
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // This is called when the i button of an annotation view is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Make sure that the annotation that is sent is from a StartPoint
        guard let location = view.annotation as? StartPoint else {return}
        let latitude: String = String(location.coordinate.latitude)
        let longitude: String = String(location.coordinate.longitude)
        let ac = UIAlertController(title: "Start Point", message: "latitude: \(latitude)\n longitude: \(longitude)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Find routes", style: .default, handler: { action in
            self.findRoutes()
        }))
        present(ac, animated: true)
    }
    
    @objc func addTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Starting point", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addTextField()
        ac.textFields![0].placeholder = "Enter latitude"
        ac.textFields![1].placeholder = "Enter longitude"
        ac.textFields![2].placeholder = "Enter distance"
        
        // Test coords - 30.371302863706674, -97.66758083066455
        let submitAction = UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] action in
            guard let latitude = ac?.textFields?[0].text else { return }
            guard let longitude = ac?.textFields?[1].text else { return }
            guard let distance = ac?.textFields?[2].text else { return }
            // Make sure all of these are doubles
            guard let doubleLatitude = latitude.toDouble() else {return}
            guard let doubleLongitude = longitude.toDouble() else {return}
            guard let doubleDistance = distance.toDouble() else { return }
            self?.submit(doubleLatitude, doubleLongitude, doubleDistance)

        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ latitude: Double, _ longitude: Double, _ distance: Double) {
        let newStartPoint = StartPoint(title: "New Start Point", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), distance: distance)
        // Remove all previous annotations
        let allAnnotations = mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        mapView.addAnnotation(newStartPoint)
    }
                                   
    func findRoutes() {
        
    }
    
}
