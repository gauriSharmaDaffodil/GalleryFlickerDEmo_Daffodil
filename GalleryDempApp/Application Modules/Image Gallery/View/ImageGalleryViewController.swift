
//This class handle view for image gallery.

import Foundation
import UIKit
import ESPullToRefresh

class ImageGalleryViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Local propertiess
    fileprivate var presenter: ImageGalleryViewPresenter!

    var zoomCollectionView: UICollectionView?
    var zoomIndexPath: IndexPath?

    lazy private var searchBar = UISearchBar(frame: CGRect.zero)
    fileprivate var searchString = ""

    fileprivate var selectedIndexPath: IndexPath?
    fileprivate var tableRowIndexPath: IndexPath?
    
    fileprivate var currentPage = 1
    fileprivate var pageSize = 10

    
    fileprivate var dataSourcePhotos: [PhotoDetailModel] = []
    fileprivate var dataSourcePhotosArray: [[PhotoDetailModel]] = []
    fileprivate var tagList: [TagListGalleryResponseModel] = []
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        presenter = ImageGalleryViewPresenter(delegate: self, tagListDelegate: self)
        tableView.es.addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.tagList.isEmpty {
            self.requestToSendTagList()
        }
    }
    
    // MARK: - Initial set up methods
    private func initView() {
        self.setUpSearchBar()
    }
    
    private func setUpSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Localization.search.description
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    // MARK: - Helper methods
    func loadMore() {
        self.presenter.sendTagListRequest(withTagListGalleryViewRequestModel: TagListGalleryViewRequestModel(page: self.pageSize))
    }
    
    func requestToSendTagList() {
        if AppLaunchSetup.isNetworkReachable() {
            self.presenter.sendTagListRequest(withTagListGalleryViewRequestModel: TagListGalleryViewRequestModel(page: self.pageSize))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.presenter.sendTagListRequest(withTagListGalleryViewRequestModel: TagListGalleryViewRequestModel(page: self.pageSize))
            }
        }
    }

    // MARK:- Base View Delegates
    override func showLoader() {
        super.showLoader()
    }
    
    override func hideLoader() {
        if self.tableView != nil {
            self.tableView.es.stopLoadingMore()
        }
        super.hideLoader()
    }
    
    override func showErrorAlert(_ alertTitle: String, alertMessage: String) {
        super.showErrorAlert(alertTitle, alertMessage: alertMessage)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ImageDetailViewController {
            viewController.image = sender as? UIImage
        }
    }
}

// MARK: - UISearchBarDelegate
extension ImageGalleryViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        searchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        searchBar.resignFirstResponder()
        if searchString != "" {
            if let searchResultViewController = UIStoryboard.init(name: AppConstants.StoryBoardID.MAIN.rawValue, bundle: nil).instantiateViewController(withIdentifier: AppConstants.ViewControllerID.SEARCH_RESULT_VC.rawValue) as? SearchResultViewController {
                searchResultViewController.bindUpDataWith(searchParam: searchString)
                self.navigationController?.pushViewController(searchResultViewController, animated: true)
            }
        } else {
            self.showErrorAlert(Localization.message.description, alertMessage: Localization.emptySearchResultMsg.description)
        }
    }
}

// MARK: - TagListGalleryViewDelegate
extension ImageGalleryViewController: TagListGalleryViewDelegate {
    func didFetchedTagList(data: [TagListGalleryResponseModel]) {
        
        self.tableView.es.stopLoadingMore()

        //Update response data source
        self.tagList = data

        //Update page size
        self.pageSize += 10

        let lastUpdatedData = self.tagList.suffix(10)
        let lastUpdatedArray = Array(lastUpdatedData)
        for eachData in lastUpdatedArray {
            self.presenter.sendImageGalleryRequest(withImageGalleryViewRequestModel: ImageGalleryViewRequestModel(page: 1, text: eachData.tagName ?? ""))
        }
    }
}

// MARK: - ImageGalleryViewDelegate
extension ImageGalleryViewController: ImageGalleryViewDelegate{

    func didFetchedImageData(data: ImageGalleryResponseModel) {
        self.tableView.es.stopLoadingMore()
        //Update response data source
        guard data.photos?.photo != nil else {return}
        
        //Update Current Page
        self.currentPage = data.photos!.page ?? 1
        guard data.photos!.photo!.count > 0 else{return}
        
        if let indexPath = self.tableRowIndexPath {
            self.tableRowIndexPath = nil
            (self.tableView.cellForRow(at: indexPath) as? ImageGalleryTableViewCell)?.currentPage += 1
            (self.tableView.cellForRow(at: indexPath) as? ImageGalleryTableViewCell)?.dataSourcePhotos += data.photos!.photo!
            (self.tableView.cellForRow(at: indexPath) as? ImageGalleryTableViewCell)?.collectionView.reloadData()
        } else {
            if self.currentPage == 1{
                self.dataSourcePhotos = data.photos!.photo!
            }
            else {
                //Update photo data source
                self.dataSourcePhotos +=  data.photos!.photo!
            }
            self.dataSourcePhotosArray.append(self.dataSourcePhotos)
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table view datasource and delegate methods
extension ImageGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tagList.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        headerView.backgroundColor = .white
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 20))
        headerLabel.text = (self.tagList[section].tagName ?? "").capitalizingFirstLetter()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        return footerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width/3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellID.IMAGE_GALLERY_TABLE_VIEW.rawValue) as? ImageGalleryTableViewCell else {
            return UITableViewCell()
        }
        
        if  self.dataSourcePhotosArray.indices.contains(indexPath.section) {
            if tableView.indexPathsForVisibleRows?.filter({$0.section == indexPath.section}) == nil {
                cell.bindUpDataWith(dataSourcePhotos: self.dataSourcePhotosArray[indexPath.section], headerString: self.tagList[indexPath.section].tagName ?? "", imageDetailViewDelegate: self, tableIndexPath: indexPath)
            } else if cell.dataSourcePhotos.isEmpty {
                cell.bindUpDataWith(dataSourcePhotos: self.dataSourcePhotosArray[indexPath.section], headerString: self.tagList[indexPath.section].tagName ?? "", imageDetailViewDelegate: self, tableIndexPath: indexPath)
            }
        }
        return cell
    }
}

// MARK: - ImageDetailViewDelegate methods
extension ImageGalleryViewController: ImageDetailViewDelegate {
    func bindDataWith(image: UIImage, collectionView: UICollectionView, indexPath: IndexPath) {
        self.zoomCollectionView = collectionView
        self.zoomIndexPath = indexPath
        self.performSegue(withIdentifier: "segueShowDetailView", sender: image)
    }

    func requestForImgList(tableRowIndexPath: IndexPath, model: ImageGalleryViewRequestModel) {
        self.tableRowIndexPath = tableRowIndexPath
        self.presenter.sendImageGalleryRequest(withImageGalleryViewRequestModel: model)
    }
}

// MARK: - ZoomingViewController
extension ImageGalleryViewController: ZoomingViewController{
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = self.zoomIndexPath {
            let cell = self.zoomCollectionView?.cellForItem(at: indexPath) as! GalleryCell
            return cell.galleryImageView
        }
        else{
            return nil
        }
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
}

