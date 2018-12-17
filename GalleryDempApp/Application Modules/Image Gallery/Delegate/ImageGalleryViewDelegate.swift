
//Notes:- This protocol is used as a interface which is used by ImageGalleryPresenter to tranfer info to ImageGallery view controller

protocol ImageGalleryViewDelegate:BaseViewProtocol {
    func didFetchedImageData(data: ImageGalleryResponseModel)
}
