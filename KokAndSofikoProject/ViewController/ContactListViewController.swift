import UIKit
import Contacts

class ContactListViewController: UIPageViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var contactList = [CNContact]()
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    override func loadViewController() {
        createMenuButton()
        loadContactList()
    }
    
    func loadContactList() {
        let contactStore = CNContactStore()
        let keys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                self.contactList.append(contact)
            }
            contactsCollectionView.dataSource = self
            contactsCollectionView.delegate = self
        }
        catch {
            createAlert(error: "Ошибка получения контактов.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContactCell
        cell.nameLabel.text = contactList[indexPath.item].givenName + " " + contactList[indexPath.item].familyName
        cell.phoneLabel.text = contactList[indexPath.item].phoneNumbers.count != 0 ? contactList[indexPath.item].phoneNumbers[0].value.stringValue : "Phone number not found"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
}

class ContactCell : UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
}
