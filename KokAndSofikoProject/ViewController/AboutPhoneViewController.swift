import UIKit

class AboutPhoneViewController: UIPageViewController {

    @IBOutlet weak var aboutPhoneTextView: UITextView!
    
    override func loadViewController() {
        createMenuButton()
        loadInfo()
    }
    
    func loadInfo() {
        var txt = ""
        txt += "UUID: " + (UIDevice.current.identifierForVendor?.uuidString)! + "\n"
        txt += "SYSTEM: " + UIDevice().systemName + " " + UIDevice().systemVersion + "\n"
        txt += "MODEL: " + UIDevice.current.modelName + "\n"
        aboutPhoneTextView.text = txt
        
        Request.new(address: "https://api.myip.com", args: [:], method: "GET", {response in
            if let json = response?.value as? [String : Any] {
                txt += "IP-ADDRESS: " + (json["ip"] as? String ?? "0.0.0.0")
                self.aboutPhoneTextView.text = txt
            }
        })
    }

}
