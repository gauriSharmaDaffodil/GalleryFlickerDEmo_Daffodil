// This file contains the view of image gallery collection cell.

import UIKit

class GalleryCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Helper methods
    func bidData(hideIndicator: Bool, hideImgView: Bool, imgURL: String){
        self.activityIndicator.isHidden = hideIndicator
        self.galleryImageView.isHidden = hideImgView
        self.galleryImageView.image = #imageLiteral(resourceName: "ic_placeholder")
        self.galleryImageView.sd_setImage(with: URL(string: imgURL), placeholderImage: #imageLiteral(resourceName: "ic_placeholder"))
    }

    override func prepareForReuse() {
        self.galleryImageView.image = nil
    }
}
