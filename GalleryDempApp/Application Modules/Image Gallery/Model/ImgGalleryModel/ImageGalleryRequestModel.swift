

//Notes:- This class is used for constructing ImageGallery Service Request Model

class ImageGalleryRequestModel {
    
    //MARK:- ImageGalleryRequestModel properties
    
    //Note :- Property Name must be same as key used in request API
    var requestBody: [String:AnyObject]!
    var requestHeader: [String:AnyObject]!
    var requestQueryParams: [String:AnyObject]!
    
    init(builderObject builder:Builder){
        //Instantiating service Request model Properties with Builder Object property
        self.requestBody = builder.requestBody
        self.requestHeader = builder.requestHeader
        self.requestQueryParams = builder.requestQueryParams
    }
    
    // This inner class is used for setting upper class properties
    internal class Builder{
        //MARK:- Builder class Properties
        //Note :- Property Name must be same as key used in request API
        var requestBody: [String:AnyObject] = [String:AnyObject]()
        var requestHeader: [String:AnyObject] = [String:AnyObject]()
        var requestQueryParams: [String:AnyObject] =  [String:AnyObject]()
        
        /**
         This method is used for adding request Header
         
         - parameter key:   Key of a Header
         - parameter value: Value corresponding to header
         
         - returns: returning Builder object
         */
        func addRequestHeader(key:String , value:String) -> Builder {
            self.requestHeader[key] = value as AnyObject?
            return self
        }
        
        /**
         This method is used for adding request params
         
         - parameter key:   Key of a Header
         - parameter value: Value corresponding to header
         
         - returns: returning Builder object
         */
        func addRequestQueryParams(key:String , value:AnyObject) -> Builder {
            self.requestQueryParams[key] = value
            return self
        }
        
        /**
         This method is used to set properties in upper class of ImageGalleryRequestModel
         and provide ImageGalleryForm1ViewViewRequestModel object.
         
         -returns : ImageGalleryRequestModel
         */
        func build()->ImageGalleryRequestModel{
            return ImageGalleryRequestModel(builderObject: self)
        }
    }
    
    /**
     This method is used for getting ImageGallery end point
     
     -returns: String containg end point
     */
    func getEndPoint()->String{
        return getQueryParamString()
    }

    
    func getQueryParamString()->String{
        var queryParam = ""
        
        for param in self.requestQueryParams{
            queryParam = "\(queryParam)&\(param.key)=\(param.value)"
        }
        
        return queryParam
    }
    
}
