import UIKit
import MapKit

class CreatePhotoViewController: UIPageViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainBtn: UIButton!
    let locManager = CLLocationManager()
    
    override func loadViewController() {
        createMenuButton()
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
    }

    @IBAction func mainBtnClick(_ sender: Any) {
        if(imageView.image == nil) {
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            if(CLLocationManager.authorizationStatus() == .authorizedAlways){
                mainBtn.isEnabled = false
                var photosInMemory : [Photo] = []
                if(UserDefaults.standard.object(forKey: "userPhotoArray") != nil) {
                    if let photosInMemoryData = UserDefaults.standard.object(forKey: "userPhotoArray") as? Data {
                        photosInMemory = NSKeyedUnarchiver.unarchiveObject(with: photosInMemoryData) as! [Photo]
                    }
                }
                let photo = Photo((locManager.location?.coordinate.latitude)!, (locManager.location?.coordinate.longitude)!, imageView.image!)
                photosInMemory.append(photo)
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: photosInMemory)
                UserDefaults.standard.set(encodedData, forKey: "userPhotoArray")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Успешно", message: "Фотография успешно сохранена на карту!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: {response in
                    self.openPage(MapViewController.self)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                createAlert(error: "Невозможно получить текущие координаты!")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = pickedImage.resized(withPercentage: 0.5)
        mainBtn.setTitle("Сохранить на карту", for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
}
