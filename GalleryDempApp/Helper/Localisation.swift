// This file contains the cases of localized string of each module.

import Foundation

enum Localization: String {
    
    case dummyData
    case search
    case message
    case emptySearchResultMsg
    case setLayoutTitle
    case selectOptionMsg
    case cancel
    case networkFailureMsg
}

// This file is used to fetch the localize string of defined case from the respective localizabe file.

extension Localization: CustomStringConvertible {
    var description: String {
        return Localization.localizeFor(key: self.rawValue)
    }
    
    /**
     This method is used to localize string.
     - parameter  key : String type argument, basically it is a name of non localize string
     - return    : returns localize string
     */
    static func localizeFor(key: String) -> String {
        var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        if result == key {
            result = Bundle.main.localizedString(forKey: key, value: nil, table: "Default")
        }
        return result
    }
}
