
//This extension handle navigation bar customizaton logic for the app

import UIKit

extension UIViewController {
    
    func addNavigationOptionButton() ->Void{
        let buttonImage: UIImage = #imageLiteral(resourceName: "OptionButton")
        let button: UIButton = UIButton(type: .custom)
        button.setImage(buttonImage, for: .normal)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(UIViewController.optionButtonClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func optionButtonClick() ->Void {
        
    }
}
