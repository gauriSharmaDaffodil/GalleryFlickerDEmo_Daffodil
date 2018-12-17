// This file holds the response object of photo detail model.

import Foundation

struct PhotoDetailModel: Codable  {
    
    var id : String?
    var secret: String?
    var server : String?
    var farm : Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case secret
        case server
        case farm
    }
}

