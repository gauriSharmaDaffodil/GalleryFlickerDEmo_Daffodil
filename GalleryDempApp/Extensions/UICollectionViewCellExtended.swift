


import UIKit

extension UICollectionViewCell {
    
    /*
     This method is a generic method to register UICollectionViewCell
     - parameter : T.Type object where <T:UICollectionViewCell>
     - return : Void
     */
    class func registerCollectionViewCell<T:UICollectionViewCell>(collectionViewCell ofType:T.Type , collectionView:UICollectionView) ->Void{
        collectionView.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: T.self))
    }
    
}
