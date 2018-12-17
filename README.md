# GalleryDemoApp #

This app connects to Flicker API and displays a list of Photos based on its tag.


## Quick Summary ##

* This app list out the different tags and respective photos as a gallery module.
* The list is displaying in a way that can be scrolled infinitely to load more photos.
* Photos are grouped using tags/category, each section is having the name of said tag/category.
* Each section/group contains one row, that is having a horizontal scrolling -infinite- set of items.
* Each item is having an image.
* When a photo is selected(cell) a new detail view is displayed that contain a larger photo.
* Photos returned by the api are cached locally using SDWebImage library.
* Users of this app can fetch photos by searching for any particular keyword.
* App use Auto Layout to support running in all iPhone screen sizing.
* App uses custom animation between the photo list and photo detail view.
* App support localisation for Hindi and English language.


## Project Configuration ##

* Version - 1.0
* Deployment Target - 12.1
* Language - Swift


## Project Architecture ##

We have used extended version of MVP for making project enterprise ready and ease to expand, test.

### Component of the project ###

#### Architecture based components: ####

* Model Layer: Responsible for holding the related data for the specific task or purpose.
* View Layer: Represents the user interface for the application window.
* Presenter: Works as a medium for interacting with the external components of the application.
* Manager layer: Extra Layer for separating the network layer from the interface or view logic.
* API Request layer: Responsible for calling web api for fetching data from server.

#### Other Components: ####

* Service Manager: Global Single end point to interact with the web based api’s. 
* Error Transformer: Responsible for constructing error and mapping with the user relevant message.
* Response Wrapper: Listener and navigator for transferring the data or error to the presenter layer.
* Base View Controller: Contains reusable methods to be used by UIViewController i.e. show/hide loader etc.


## Application's Dependency ##
* AFNetworking for network layer.
* SDWebImage for image caching.
* ESPullToRefresh for infinite scrolling.
* SVProgressHUD for loader.


## API(s) Description ##
* This app is using following Flicker's API:
* Category/Header listing: https://api.flickr.com/v2/tags/trending/2000?pageSize=<pageSize>
* Search result: https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=<api_key>&per_page=<per_page_limit>&format=json&nojsoncallback=1&text=<textString>&page=<current_page>


## Who do I talk to? ##
* Repo owner or admin
* Other community or team contact
