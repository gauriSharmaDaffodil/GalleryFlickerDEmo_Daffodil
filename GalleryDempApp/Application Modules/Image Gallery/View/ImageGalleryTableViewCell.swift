

import UIKit
import SDWebImage

class ImageGalleryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Local properties

    fileprivate var headerString: String?
    fileprivate weak var imageDetailViewDelegate: ImageDetailViewDelegate?
    
    private let cellSpacing : CGFloat = 10
    private var cellPerRow : CGFloat = 3
    var currentPage = 1
    fileprivate var selectedIndexPath: IndexPath?
    fileprivate var tableIndexPath: IndexPath?
    
    fileprivate var dataSourceResponse: ImageGalleryResponseModel?
    var dataSourcePhotos: [PhotoDetailModel] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Helper methods
    func bindUpDataWith(dataSourcePhotos: [PhotoDetailModel], headerString: String,imageDetailViewDelegate: ImageDetailViewDelegate, tableIndexPath: IndexPath) {
        self.imageDetailViewDelegate = imageDetailViewDelegate
        self.headerString = headerString
        self.tableIndexPath = tableIndexPath
        self.dataSourcePhotos = dataSourcePhotos
    }
    
    func showLoader() {
    }
    
    func hideLoader() {
    }
    
    func showErrorAlert(_ alertTitle: String, alertMessage: String) {
    }
    
    override func prepareForReuse() {
        self.dataSourcePhotos = []
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ImageGalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourcePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == self.dataSourcePhotos.count - 1 {
            galleryCell.activityIndicator.isHidden = false
            galleryCell.galleryImageView.isHidden = true
            if AppLaunchSetup.isNetworkReachable() {
                if let rowIndexPath = self.tableIndexPath {
                    self.imageDetailViewDelegate?.requestForImgList(tableRowIndexPath: rowIndexPath, model: ImageGalleryViewRequestModel(page: self.currentPage+1, text: headerString))
                }
            } else {
                let dataSource = self.dataSourcePhotos[indexPath.row]
                let imgURL = "https://farm\(dataSource.farm!).staticflickr.com/\(dataSource.server!)/\(dataSource.id!)_\(dataSource.secret!).jpg"
                galleryCell.bidData(hideIndicator: true, hideImgView: false, imgURL: imgURL)
            }
        } else {
            if self.dataSourcePhotos.indices.contains(indexPath.row) {
                let dataSource = self.dataSourcePhotos[indexPath.row]
                let imgURL = "https://farm\(dataSource.farm!).staticflickr.com/\(dataSource.server!)/\(dataSource.id!)_\(dataSource.secret!).jpg"
                galleryCell.bidData(hideIndicator: true, hideImgView: false, imgURL: imgURL)
            }
        }

        return galleryCell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCell
        self.selectedIndexPath = indexPath
        if let delegate = self.imageDetailViewDelegate {
            if cell.galleryImageView.image != nil && cell.galleryImageView.image != #imageLiteral(resourceName: "ic_placeholder") {
                delegate.bindDataWith(image: cell.galleryImageView.image!, collectionView: self.collectionView, indexPath: indexPath)
            }
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ImageGalleryTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.bounds.size
        collectionViewSize.width = (collectionViewSize.width - ((cellPerRow - 1) * cellSpacing))/cellPerRow
        collectionViewSize.height = collectionViewSize.width
        return collectionViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}




