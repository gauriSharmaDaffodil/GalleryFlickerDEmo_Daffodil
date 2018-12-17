

import Foundation

enum AppConstants: String{
    
    case API_KEY_FLICKR = "d6e9076d88ebe3a17deefafe43c70aac"
    case API_SECRET = "6c03c6038b58d88b"
    case API_PAGESIZE = "pageSize"
    
    enum URL: String{
        case IMAGE_SEARCH_URL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d6e9076d88ebe3a17deefafe43c70aac&per_page=30&format=json&nojsoncallback=1"
        case TAG_LIST_URL = "https://api.flickr.com/v2/tags/trending/2000?pageSize="
    }
    
    enum ErrorHandlingKeys: String{
        case ERROR_TITLE = "Title"
    }
    
    enum ErrorMessages: String{
        case REQUEST_TIME_OUT = "Request Time Out"
        case PLEASE_CHECK_YOUR_INTERNET_CONNECTION = "Please check your internet connection"
        case SOME_ERROR_OCCURED = "Some error occured"
    }
    
    enum APIRequestHeaders: String{
        case CONTENT_TYPE = "Content-Type"
        case APPLICATION_JSON = "application/json"
    }

    enum StoryBoardID: String {
        case MAIN = "Main"
    }

    enum ViewControllerID: String {
        case IMAGE_DETAIL_VC = "ImageDetailViewController"
        case SEARCH_RESULT_VC = "SearchResultViewController"
    }
    
    enum CellID: String {
        case IMAGE_GALLERY_TABLE_VIEW = "ImageGalleryTableViewCell"
    }
}
