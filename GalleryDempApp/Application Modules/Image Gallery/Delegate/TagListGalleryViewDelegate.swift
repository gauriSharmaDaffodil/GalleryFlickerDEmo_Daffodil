
//Notes:- This protocol is used as a interface to share the info to ImageGalleryViewController.

protocol TagListGalleryViewDelegate: BaseViewProtocol {
    func didFetchedTagList(data: [TagListGalleryResponseModel])
}
