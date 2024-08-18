//
//  MapViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var trip: Trip?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var listContainerView: UIView!
    
    @IBOutlet weak var sugestionsContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var sugRestaurantButton: UIButton!
    
    @IBOutlet weak var sugCoffeeButton: UIButton!
    
    @IBOutlet weak var sugHotelButton: UIButton!
    
    @IBOutlet weak var sugSightsButton: UIButton!
    
    @IBOutlet weak var sugStoreButton: UIButton!
    
    @IBOutlet weak var sugParkingButton: UIButton!
    
    
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!

    
    
    private var landmarks: [Landmark] = []
    
    private var selectedLandmark: Landmark?
    
    private var destination:MKPointAnnotation?
    
    
    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.4643, longitude: -80.5204),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
        
        tableView.dataSource = self
        tableView.delegate = self
        
        mapView.delegate = self
        mapView.setRegion(region, animated: true)

        
        segmentedControl.addTarget(self, action: #selector(updateView), for: .valueChanged)
                updateView()
        
        searchTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        
        if let dest = trip?.destination, !dest.isEmpty {
            updateRegionFromAddress(address: (trip?.destination)!)
            statusView.isHidden = true
        } else {
            statusLabel.text = Constants.Destination.withoutDestination
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabBar = tabBarController as! TabBarViewController
        tabBar.objTrip = trip
    }
    
    @objc private func textFieldChange(_ textField: UITextField) {
        if let query = textField.text, !query.isEmpty {
//            print(textField.text)
            sugestionsContainerView.isHidden = true
            search(query: textField.text!)
            tableView.reloadData()
            return
        } else {
            sugestionsContainerView.isHidden = false
        }
        
    }
    
    @objc private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            mapContainerView.isHidden = false
            listContainerView.isHidden = true
            sugestionsContainerView.isHidden = true
        } else {
            mapContainerView.isHidden = true
            listContainerView.isHidden = false
            if let query = searchTextField.text, !query.isEmpty {
                sugestionsContainerView.isHidden = true
            } else {
                sugestionsContainerView.isHidden = false
            }
        }
    }
    
    
    @IBAction func goToCurrentLocation(_ sender: Any) {
        self.search(query: "City Hall")
        statusView.isHidden = true
    }
    
    private func search(query: String) {
//        print(query)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.landmarks = response.mapItems.map { Landmark(placemark: $0.placemark) }
            self.tableView.reloadData()
            self.updateMapAnnotations()
        }
//        print(landmarks)
    }
    
    //MARK: Places sugestions ---
    @IBAction func restaurantsButton(_ sender: Any) {
        setByButton(place:"Restaurants")
    }
    
    @IBAction func coffeeButton(_ sender: Any) {
        setByButton(place:"Coffee shops")
    }
    
    @IBAction func hotelsButton(_ sender: Any) {
        setByButton(place:"Hotels")
    }
    
    @IBAction func sightsButton(_ sender: Any) {
        setByButton(place:"Sights")
    }
    
    @IBAction func shoppingButton(_ sender: Any) {
        setByButton(place:"shopping")
    }
    
    @IBAction func parkingButton(_ sender: Any) {
        setByButton(place:"Parking")
    }
    
    func setByButton(place:String){
        search(query: place)
        searchTextField.text = place
        sugestionsContainerView.isHidden = true
    }
    
    
    //MARK: Map functions ---
    //Update from list
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = landmarks.map { landmark -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = landmark.coordinate
            annotation.title = landmark.name
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    // Set original destination
    private func updateRegionFromAddress(address: String) {
        let geocoder = CLGeocoder()
//        print(address)
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                //TODO: Add alert
                print("Error: \(error.localizedDescription)")
                return
            }
                
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                self.mapView.setRegion(self.region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = address
                
                self.destination = annotation //To update the landmark
                self.mapView.addAnnotation(annotation)
            } else {
                //TODO: Add alert
                print("No location")
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "LandmarkAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // From list
        if let title = annotation.title, let landmark = landmarks.first(where: { $0.name == title }) {
            if landmark == selectedLandmark {
                annotationView?.markerTintColor = .blue
            } else {
                annotationView?.markerTintColor = .red
            }
        }
        
        // Original address pin
        if annotation === destination {
            annotationView?.markerTintColor = .blue
        }
        
        return annotationView
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MapViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        selectedLandmark = landmarks[indexPath.row]
        
        cell.textLabel?.text = selectedLandmark?.name
        if let latitude = selectedLandmark?.coordinate.latitude, let longitude = selectedLandmark?.coordinate.longitude {
            cell.detailTextLabel?.text = "\(latitude), \(longitude)"
        } else {
            cell.detailTextLabel?.text = "Ops! Something wrong, coordinates not available"
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLandmark = landmarks[indexPath.row]
        mapView.setCenter(selectedLandmark!.coordinate, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        updateView()
        updateMapAnnotations()
    }
}
