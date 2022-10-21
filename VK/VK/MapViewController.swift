import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private lazy var mapView = MKMapView()
    private var locationManager = CLLocationManager()
    private var deletePinsButton: UIButton = {
        var button = UIButton()
        button.setTitle("delete_all_pins".localized, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deletePins),for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .appBackgroundColor
        setupMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        checkUserLocationPermissions()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress))
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
}

extension MapViewController {
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addRoute(location: coordinate)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addPin(location: coordinate)
    }
    
    @objc func deletePins() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        view.addSubview(deletePinsButton)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .hybrid
        mapView.isRotateEnabled = false
        mapView.setCenter(locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 40.7143, longitude: -74.006), animated: true)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            deletePinsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            deletePinsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addRoute(location: CLLocationCoordinate2D) {
        let directionRequest = MKDirections.Request()
        let sourcePlaceMark = MKPlacemark(coordinate: location)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
 
        let destinationPlaceMark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0,  longitude: 0))
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
 
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
 
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
 
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
 
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
   }
    
    private func addPin(location: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = "Your pin"
        mapView.addAnnotation(pin)
    }
    
    private func checkUserLocationPermissions() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied, .restricted:
            print("Попросить пользователя изменить в настройках")
        @unknown default:
            fatalError("Необрабатываемый статус")
        }
    }
}

extension String {
    var localized: String  {
        NSLocalizedString(self, comment: "")
    }
}
