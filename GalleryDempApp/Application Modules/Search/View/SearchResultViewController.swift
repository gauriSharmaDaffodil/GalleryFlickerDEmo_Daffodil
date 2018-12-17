// This file handle the view of Search result of image gallery.

import UIKit

class SearchResultViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emptySearchResultLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Local properties
    private var presenter: SearchViewPresenter!
    fileprivate var selectedIndexPath: IndexPath?
    private var currentPage = 1
    private var searchString: String = ""
    private let cellSpacing : CGFloat = 10
    private var cellPerRow : CGFloat = 3 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    fileprivate var dataSourcePhotos: [PhotoDetailModel] = [] {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationOptionButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.collectionView != nil {
            self.collectionView.es.addInfiniteScrolling { [weak self] in
                self?.loadMore()
            }
        }
    }
    
    // MARK: - Helper methods
    func bindUpDataWith(searchParam: String) {
        self.searchString = searchParam
        presenter = SearchViewPresenter(delegate: self)
        self.requestForImageGalleryWith(page: self.currentPage)
    }

    func loadMore() {
        self.requestForImageGalleryWith(page: self.currentPage+1)
    }
    
    func requestForImageGalleryWith(page: Int) {
        if AppLaunchSetup.isNetworkReachable() {
            self.presenter.sendImageGalleryRequest(withImageGalleryViewRequestModel: ImageGalleryViewRequestModel(page: page, text: self.searchString))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.presenter.sendImageGalleryRequest(withImageGalleryViewRequestModel: ImageGalleryViewRequestModel(page: page, text: self?.searchString))
            }
        }
    }

    override func showErrorAlert(_ alertTitle: String, alertMessage: String) {
        super.showErrorAlert(alertTitle, alertMessage: alertMessage)
    }
    
    override func hideLoader() {
        if self.collectionView != nil {
            self.collectionView.es.stopLoadingMore()
        }
        super.hideLoader()
    }
    
    /// This method is used to select the kind of layout we expect
    private  func showAlert() {
        let alert = UIAlertController(title: Localization.setLayoutTitle.description, message: Localization.selectOptionMsg.description, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "2", style: .default , handler:{ (UIAlertAction)in
            self.cellPerRow = 2
        }))
        
        alert.addAction(UIAlertAction(title: "3", style: .default , handler:{ (UIAlertAction)in
            self.cellPerRow = 3
        }))
        
        alert.addAction(UIAlertAction(title: "4", style: .default , handler:{ (UIAlertAction)in
            self.cellPerRow = 4
        }))
        
        alert.addAction(UIAlertAction(title: Localization.cancel.description, style: .cancel, handler:nil))
        self.present(alert, animated: true, completion:nil)
    }

    override func optionButtonClick(){
        self.showAlert()
    }
}

// MARK: - ImageGalleryViewDelegate
extension SearchResultViewController: ImageGalleryViewDelegate {
    func didFetchedImageData(data: ImageGalleryResponseModel) {
        collectionView.es.stopLoadingMore()
        guard data.photos?.photo != nil else {
            self.collectionView.isHidden = true
            self.emptySearchResultLabel.isHidden = false
            return
        }
        self.currentPage = data.photos!.page ?? 1
        guard data.photos!.photo!.count > 0 else{
            self.collectionView.isHidden = true
            self.emptySearchResultLabel.isHidden = false
            return
        }
        
        if self.currentPage == 1{
            self.dataSourcePhotos = data.photos!.photo!
        }
        else{
            self.dataSourcePhotos +=  data.photos!.photo!
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourcePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        galleryCell.galleryImageView.image = #imageLiteral(resourceName: "ic_placeholder")
        let dataSource = self.dataSourcePhotos[indexPath.row]
        let imgURL = "https://farm\(dataSource.farm!).staticflickr.com/\(dataSource.server!)/\(dataSource.id!)_\(dataSource.secret!).jpg"
        ImageDownloadManager.shared.getImageWithURL(urlString: imgURL, indexPath: indexPath, onCompletion: { (url, image) in
            DispatchQueue.main.async {
                galleryCell.galleryImageView.image = image
            }
        }) { (url) in
        }
        return galleryCell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCell
        self.selectedIndexPath = indexPath
        if let imageDetailVC = UIStoryboard.init(name: AppConstants.StoryBoardID.MAIN.rawValue, bundle: nil).instantiateViewController(withIdentifier: AppConstants.ViewControllerID.IMAGE_DETAIL_VC.rawValue) as? ImageDetailViewController {
            if cell.galleryImageView.image != nil && cell.galleryImageView.image != #imageLiteral(resourceName: "ic_placeholder") {
                imageDetailVC.image = cell.galleryImageView.image
                self.navigationController?.pushViewController(imageDetailVC, animated: true)
            }
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout{
    
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


// MARK: - This extension handle for custom action on scroll
extension SearchResultViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleLowPriorityTasks()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.handleLowPriorityTasks()
    }

    func handleLowPriorityTasks(){
        let arrHighPriorityTaskIndex = self.collectionView.indexPathsForVisibleItems
        let allRunningTaskIndex = ImageDownloadManager.shared.getIndexPathForAllExecutingTasks()
        
        let lowPriorityTaskIndex = allRunningTaskIndex.drop { (indexPath) -> Bool in
            return !arrHighPriorityTaskIndex.contains(indexPath)
        }
        ImageDownloadManager.shared.reducePriorityForTasks(withIndexPaths: Array(lowPriorityTaskIndex))
    }
}
