import UIKit

class LeftMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var menu : [MenuElement] = []
    static var className: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        menu.append(MenuElement("Список репозиториев", RepositoryListViewController.self))
        menu.append(MenuElement("Список контактов", ContactListViewController.self))
        menu.append(MenuElement("Фото", CreatePhotoViewController.self))
        menu.append(MenuElement("Карта", MapViewController.self))
        menu.append(MenuElement("Об устройстве", AboutPhoneViewController.self))
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
        cell.titleLabel.text = menu[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openPage(menu[indexPath.item].page!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }

    func openPage(_ page: UIPageViewController.Type) {
        UIPageViewController.curView?.openPage(page, false)
        dismiss(animated: true, completion: nil)
    }

}

class MenuElement {
    
    var title : String = ""
    var page : UIPageViewController.Type? = nil
    
    init(_ title: String, _ page: UIPageViewController.Type) {
        self.title = title
        self.page = page
    }
    
}

class MenuCell : UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}
