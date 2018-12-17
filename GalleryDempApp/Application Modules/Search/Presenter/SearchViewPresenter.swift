//Notes:- This class is used as presenter for SearchResultViewController

import Foundation

class SearchViewPresenter: ResponseCallback {
    
    //MARK:- local properties
    private weak var imageGalleryViewDelegate    : ImageGalleryViewDelegate?
    private lazy var imageGalleryManager         : ImageGalleryManager = ImageGalleryManager()
    
    //MARK:- Constructor
    
    init(delegate imageGalleryDelegate:ImageGalleryViewDelegate) {
        self.imageGalleryViewDelegate = imageGalleryDelegate
    }
    
    //MARK:- ResponseCallback delegate methods
    
    func servicesManagerSuccessResponse<T:Codable>(responseObject : T) {
        if let response = responseObject as? ImageGalleryResponseModel {
            self.imageGalleryViewDelegate?.didFetchedImageData(data: response)
            self.imageGalleryViewDelegate?.hideLoader()
        }
    }
    
    func servicesManagerError(error: ErrorModel) {
        if self.imageGalleryViewDelegate != nil {
            self.imageGalleryViewDelegate?.showErrorAlert(error.getErrorTitle(), alertMessage: error.getErrorMessage())
            self.imageGalleryViewDelegate?.hideLoader()
        }
    }
    
    //MARK:- Methods to make decision and call ImageGallery Api.
    
    // Invoking image gallery list manager
    func sendImageGalleryRequest(withImageGalleryViewRequestModel imageGalleryViewRequestModel:ImageGalleryViewRequestModel){
        self.imageGalleryViewDelegate?.showLoader()
        let requestModel = ImageGalleryRequestModel.Builder()
            .addRequestQueryParams(key: "page", value: imageGalleryViewRequestModel.page as AnyObject)
            .addRequestQueryParams(key: "text", value: imageGalleryViewRequestModel.text! as AnyObject)
            .addRequestHeader(key:AppConstants.APIRequestHeaders.CONTENT_TYPE.rawValue, value: AppConstants.APIRequestHeaders.APPLICATION_JSON.rawValue)
            .build()
        
        self.imageGalleryManager.performImageGallery(withImageGalleryRequestModel: requestModel, presenterDelegate: self)
    }
}
