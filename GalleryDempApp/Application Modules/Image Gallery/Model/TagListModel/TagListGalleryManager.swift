
//Note :- This class manage the tag list service invocation logic.

class TagListGalleryManager {
    
    
    deinit {
        print("TagListGalleryManager deinit")
    }
    
    /**
     This method is used for perform TagListGallery With Valid Inputs constructed into a TagListGalleryRequestModel
     
     - parameter inputData: Contains info for TagList
     - parameter success:   Returning Success Response of API
     - parameter failure:   NSError Response Contaons ErrorInfo
     */
    func performTagListGallery(withTagListGalleryRequestModel tagListGalleryRequestModel: TagListGalleryRequestModel, presenterDelegate:ResponseCallback) ->Void {
        
        //Adding predefined set of errors
        let errorResolver:ErrorResolver = ErrorResolver.registerErrorsForApiRequests()
        TagListGalleryAPIRequest().makeAPIRequest(withReqFormData: tagListGalleryRequestModel, errorResolver: errorResolver, responseCallback: presenterDelegate)
    }
    
    
    /**
     This method is used for adding set of Predefined Error coming from server
     */
    private func registerErrorForTagListGallery() ->ErrorResolver{
        
        let errorResolver:ErrorResolver = ErrorResolver.registerErrorsForApiRequests() //ErrorResolver()
        
        return errorResolver
    }
}
