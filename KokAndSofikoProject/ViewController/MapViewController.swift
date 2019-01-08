import UIKit
import GoogleMaps

class MapViewController: UIPageViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    let locManager = CLLocationManager()
    var markerImgViews : [UIImageView] = []
    var gmspath = GMSPath()
    var pathLine = GMSPolyline()
    
    override func loadViewController() {
        createMenuButton()
        loadMap()
        loadPhotoList()
        calculatePath()
    }
    
    func loadMap() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 13)
        mapView.delegate = self
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.first != nil && mapView != nil) {
            mapView.camera = GMSCameraPosition(target: locations.first!.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
            locManager.stopUpdatingLocation()
        }
    }
    
    func loadPhotoList() {
        var photosInMemory : [Photo] = []
        if(UserDefaults.standard.object(forKey: "userPhotoArray") != nil) {
            if let photosInMemoryData = UserDefaults.standard.object(forKey: "userPhotoArray") as? Data {
                photosInMemory = NSKeyedUnarchiver.unarchiveObject(with: photosInMemoryData) as! [Photo]
            }
        }
        markerImgViews.removeAll()
        for photo in photosInMemory {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude))
            let size = 40
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            imgView.image = photo.photo
            imgView.layer.cornerRadius = CGFloat(size / 2)
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.autoresizesSubviews = false
            marker.iconView = imgView
            marker.map = mapView
            markerImgViews.append(imgView)
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        var size = Int((position.zoom - 11) * 25)
        size = size < 10 ? 0 : size
        size = size > 100 ? 100 : size
        for markerView in markerImgViews {
            markerView.frame.size = CGSize(width: size, height: size)
            markerView.layer.cornerRadius = CGFloat(size / 2)
        }
    }
    
    func calculatePath() {
        Request.new(address: "https://maps.googleapis.com/maps/api/directions/json?origin=Москва+Метро+Сокольники&destination=Москва+Стромынка+20&key=AIzaSyB-wIXRYWjfhwnJUcS9iri_sMSu3Qoucx8", method: "GET", {response in
            let path = response?.value as! [String : Any]
            if(path["routes"] == nil || path["routes"] as? [Any] == nil || (path["routes"] as? [Any])?.count == 0) {
                self.createAlert(error: "Ошибка получения точек пути!")
                return
            }
            
            let routes = (path["routes"] as! [Any])[0] as! [String : Any]
            let overview_polyline = routes["overview_polyline"] as! [String : Any]
            let points = overview_polyline["points"] as! String
            self.gmspath = GMSPath.init(fromEncodedPath: points)!
            self.drawPath()
        })
    }
    
    func drawPath(){
        pathLine.map = nil
        pathLine = GMSPolyline(path: gmspath)
        pathLine.strokeColor = UIColor(red: 1, green: 0.75, blue: 0.8, alpha: 0.5)
        pathLine.strokeWidth = 5
        pathLine.map = mapView
    }

}
