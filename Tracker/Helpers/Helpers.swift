


struct Helpers {
    static func countDays(countDays: Int) -> String {
        var text: String = ""
        
        if countDays >= 11 && countDays <= 20 {
            text = "дней"
        } else {
            let remainderValue = countDays % 10
            switch remainderValue {
            case 1:
                text = "день"
            case 2, 3, 4:
                text = "дня"
            default:
                text = "дней"
            }
        }
        return "\(countDays) \(text)"
    }
}
