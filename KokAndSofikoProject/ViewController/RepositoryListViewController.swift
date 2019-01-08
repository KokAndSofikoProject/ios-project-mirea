import UIKit

class RepositoryListViewController: UIPageViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    @IBOutlet weak var repositoryCollectionView: UICollectionView!
    var repositoryList : [Repository] = []
    override func loadViewController() {
        createMenuButton()
        getRepositoryList()
    }
    
    func getRepositoryList() {
        RepositoryController.getRepoList(authData: "KokAndSofikoProject:aafsdf234af", {repositoryList in
            self.repositoryList = repositoryList
            self.repositoryCollectionView.dataSource = self
            self.repositoryCollectionView.delegate = self
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RepositoryCell
        cell.nameLabel.text = repositoryList[indexPath.item].name
        cell.idLabel.text = "ID: " + String(repositoryList[indexPath.item].id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
}

class RepositoryCell : UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
}
