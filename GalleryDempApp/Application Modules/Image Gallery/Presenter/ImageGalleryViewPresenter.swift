
//Notes:- This class is used as presenter for ImageGalleryViewPresenter

import Foundation

class ImageGalleryViewPresenter: ResponseCallback{
    
//MARK:- local properties
    
    private weak var imageGalleryViewDelegate    : ImageGalleryViewDelegate?
    private lazy var imageGalleryManager         : ImageGalleryManager = ImageGalleryManager()
    private weak var tagListGalleryViewDelegate  : TagListGalleryViewDelegate?
    private lazy var tagListGalleryManager       : TagListGalleryManager = TagListGalleryManager()

//MARK:- Constructor
    
    init(delegate imageGalleryDelegate:ImageGalleryViewDelegate, tagListDelegate:TagListGalleryViewDelegate) {
        self.imageGalleryViewDelegate = imageGalleryDelegate
        self.tagListGalleryViewDelegate = tagListDelegate
    }
    
//MARK:- ResponseCallback delegate methods
    
    func servicesManagerSuccessResponse<T:Codable>(responseObject : T) {
        if let response = responseObject as? ImageGalleryResponseModel {
            self.imageGalleryViewDelegate?.didFetchedImageData(data: response)
        self.imageGalleryViewDelegate?.hideLoader()
        } else if let response = responseObject as? [TagListGalleryResponseModel] {
            self.tagListGalleryViewDelegate?.didFetchedTagList(data: response)
            self.tagListGalleryViewDelegate?.hideLoader()
        }
    }
    
    func servicesManagerError(error: ErrorModel) {
        if self.imageGalleryViewDelegate != nil {
            self.imageGalleryViewDelegate?.showErrorAlert(error.getErrorTitle(), alertMessage: error.getErrorMessage())
            self.imageGalleryViewDelegate?.hideLoader()
        } else if self.tagListGalleryViewDelegate != nil {
            self.tagListGalleryViewDelegate?.showErrorAlert(error.getErrorTitle(), alertMessage: error.getErrorMessage())
            self.tagListGalleryViewDelegate?.hideLoader()
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

    // Invoking tag list manager
    func sendTagListRequest(withTagListGalleryViewRequestModel tagListGalleryViewRequestModel:TagListGalleryViewRequestModel){
        self.tagListGalleryViewDelegate?.showLoader()
        let requestModel = TagListGalleryRequestModel.Builder()
            .addRequestQueryParams(key: AppConstants.API_PAGESIZE.rawValue, value: tagListGalleryViewRequestModel.page as AnyObject)
            .addRequestHeader(key:AppConstants.APIRequestHeaders.CONTENT_TYPE.rawValue, value: AppConstants.APIRequestHeaders.APPLICATION_JSON.rawValue)
            .build()
        self.tagListGalleryManager.performTagListGallery(withTagListGalleryRequestModel: requestModel, presenterDelegate: self)
    }
}
