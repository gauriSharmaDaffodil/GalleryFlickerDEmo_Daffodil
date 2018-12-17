
//Note :- This class manage the image list service invocation logic.

class ImageGalleryManager {
    
    /**
     This method is used for perform ImageGallery With Valid Inputs constructed into a ImageGalleryRequestModel
     
     - parameter inputData: Contains info for ImageGallery
     - parameter success:   Returning Success Response of API
     - parameter failure:   NSError Response Contaons ErrorInfo
     */
    func performImageGallery(withImageGalleryRequestModel ImageGalleryRequestModel: ImageGalleryRequestModel, presenterDelegate:ResponseCallback) ->Void {
        
        //Adding predefined set of errors
        let errorResolver:ErrorResolver = ErrorResolver.registerErrorsForApiRequests() //self.registerErrorForImageGallery()
        ImageGalleryApiRequest().makeAPIRequest(withReqFormData: ImageGalleryRequestModel, errorResolver: errorResolver, responseCallback: presenterDelegate)
    }
    
    
    /**
     This method is used for adding set of Predefined Error coming from server
     */
    private func registerErrorForImageGallery() ->ErrorResolver{
        
        let errorResolver:ErrorResolver = ErrorResolver.registerErrorsForApiRequests() //ErrorResolver()
        
        return errorResolver
    }
}
