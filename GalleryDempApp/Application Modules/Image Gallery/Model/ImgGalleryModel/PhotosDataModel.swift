// This file holds the response object of photo data model.

import Foundation

struct PhotosDataModel: Codable  {
    
    var page : Int?
    var pages: Int?
    var photo : [PhotoDetailModel]?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case pages
        case photo
    }
}

