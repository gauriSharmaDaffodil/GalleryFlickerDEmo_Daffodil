// This file holds thr response object of image gallery

import Foundation

struct ImageGalleryResponseModel: Codable  {
    
    var photos : PhotosDataModel?
    
    private enum CodingKeys: String, CodingKey {
        case photos
    }
}
