import UIKit
import SideMenu

class UIPageViewController: UIViewController {

    static var curView : UIPageViewController? = nil
    var loadDataCount = 0
    var loadingView : UILabel? = nil
    
    static var className: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoadingView()
        UIPageViewController.curView = self
        loadViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIPageViewController.curView = self
    }
    
    func loadViewController() {
    }
    
    func createLeftMenu() {
        if(SideMenuManager.default.menuLeftNavigationController == nil) {
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: LeftMenuViewController.className))!)
            SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
            SideMenuManager.defaultManager.menuPresentMode = .menuSlideIn
            SideMenuManager.defaultManager.menuWidth = self.view.frame.width - 100
            SideMenuManager.defaultManager.menuEnableSwipeGestures = true
            SideMenuManager.defaultManager.menuFadeStatusBar = false
            if(self.navigationController != nil) {
                SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
                SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
            }
        }
    }
    
    func openPage(_ page: UIPageViewController.Type, _ animated: Bool = true){
        let page = self.storyboard?.instantiateViewController(withIdentifier: page.className)
        self.navigationController?.pushViewController((page as! UIPageViewController) as UIViewController, animated: animated)
    }
    
    func createMenuButton() {
        createLeftMenu()
        let button = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(menuButtonClick))
        button.tintColor = UIColor.black
        button.image = UIImage(named: "menu")
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc func menuButtonClick() {
        if let leftMenuNavController = SideMenuManager.default.menuLeftNavigationController {
            present(leftMenuNavController, animated: true, completion: nil)
        }
    }
    
    func createAlert(error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createLoadingView() {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height / 2 - 20, width: self.view.frame.width, height: 45))
        label.font = label.font.withSize(40)
        label.isHidden = true
        label.text = "Идет загрузка"
        label.textAlignment = .center
        loadingView = label
        self.view.addSubview(label)
    }
    
    func startLoading() {
        loadDataCount += 1
        loadingView?.isHidden = false
    }
    
    func stopLoading() {
        loadDataCount -= 1
        if(loadDataCount == 0) {
            loadingView?.isHidden = true
        }
    }
    
}
