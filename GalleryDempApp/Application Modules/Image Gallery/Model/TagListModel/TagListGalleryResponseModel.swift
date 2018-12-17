// This file contains the response model of Tag list API

import Foundation

struct TagListGalleryResponseModel: Codable  {
    var tagName: String?
    
    private enum CodingKeys: String, CodingKey {
        case tagName
    }
}


