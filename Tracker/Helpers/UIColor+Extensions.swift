
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func getUIColor(index: Int) -> UIColor {
        if index >= 1 && index <= 18 {
            return UIColor(resource: .init(name: "TrackerColor\(index)", bundle: .main))
        }
        let randomNumber = Int.random(in: 1...18)
        return UIColor(resource: .init(name: "TrackerColor\(randomNumber)", bundle: .main))
    }
    
    static func getIndex(color: UIColor) -> Int? {
        for i in 0...17 {
            let trackerColor: UIColor = UIColor(resource: .init(name: "TrackerColor\(i + 1)", bundle: .main))
            let colorString = color.toHexString()
            
            if trackerColor.toHexString() == colorString {
                return i
            }
        }
        return nil
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        // Получаем RGBA компоненты (в диапазоне 0.0 - 1.0)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Преобразуем в 8-битные значения (0 - 255) и форматируем
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06X", rgb)
    }
}
