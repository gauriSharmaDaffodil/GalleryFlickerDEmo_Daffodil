// This file contains the business logic to extend the behaviour of String object

extension String {
    
    // MARK: - Firstletter capital behaviour
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
