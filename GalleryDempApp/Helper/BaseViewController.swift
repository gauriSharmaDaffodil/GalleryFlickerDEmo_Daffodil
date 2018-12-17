//All UIViewController must inherit from base view controller

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController, BaseViewProtocol {

    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - BaseViewProtocol methods
    func showLoader() {
        SVProgressHUD.show()
    }

    func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    func showErrorAlert(_ alertTitle: String, alertMessage: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
