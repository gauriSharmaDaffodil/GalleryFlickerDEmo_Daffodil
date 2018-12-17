// This file containsthe view of image detail

import UIKit

class ImageDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!

    // MARK: - Local properties
    var image: UIImage?

    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = image
    }
}

// MARK: - ZoomingViewController delegate methods
extension ImageDetailViewController: ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return imgView
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
}


