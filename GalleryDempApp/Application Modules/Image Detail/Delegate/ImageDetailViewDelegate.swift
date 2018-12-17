// This protocol used to send info to ImageDetail view controller from image gallery section.

import UIKit

protocol ImageDetailViewDelegate: class {
    func bindDataWith(image: UIImage, collectionView: UICollectionView, indexPath: IndexPath)
    func requestForImgList(tableRowIndexPath: IndexPath, model: ImageGalleryViewRequestModel)
}
