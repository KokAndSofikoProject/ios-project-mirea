import UIKit

class Photo: NSObject, NSCoding  {

    var latitude : Double = 0
    var longitude : Double = 0
    var photo : UIImage = UIImage()
    
    init(_ latitude: Double, _ longitude: Double, _ photo: UIImage) {
        self.latitude = latitude
        self.longitude = longitude
        self.photo = photo
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(photo, forKey: "photo")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        let photo = aDecoder.decodeObject(forKey: "photo") as! UIImage
        self.init(latitude, longitude, photo)
    }
    
}
