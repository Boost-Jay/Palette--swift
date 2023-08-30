import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IBOutlet
    
    @IBOutlet weak var palatte: UIView!             // 調色板的 View
    @IBOutlet weak var redSlider: UISlider!         // 紅色Slider
    @IBOutlet weak var greenSlider: UISlider!       // 綠色滑軌
    @IBOutlet weak var blueSlider: UISlider!        // 藍色滑軌
    @IBOutlet weak var redValue: UITextField!       // 紅色數值的文字欄位
    @IBOutlet weak var greenValue: UITextField!     // 綠色數值的文字欄位
    @IBOutlet weak var blueValue: UITextField!      // 藍色數值的文字欄位
    @IBOutlet weak var redSwitch: UISwitch!         // 紅色開關
    @IBOutlet weak var greenSwitch: UISwitch!       // 綠色開關
    @IBOutlet weak var blueSwitch: UISwitch!        // 藍色開關
    @IBOutlet weak var colorPicker: UIPickerView!   // 顏色選擇器
    @IBOutlet weak var hexTextField: UITextField!   // 用於顯示和編輯十六進制顏色代碼的文字欄位
    @IBOutlet weak var redView: UIView!             // 用於顯示紅色的 View
    @IBOutlet weak var greenView: UIView!           // 用於顯示綠色的 View
    @IBOutlet weak var blueView: UIView!            // 用於顯示藍色的 View
    @IBOutlet weak var alphaSlider: UISlider!       // 用於調整透明度的滑軌
    @IBOutlet weak var imageView: UIImageView!      // 用於顯示圖片的 ImageView

    // MARK: - Enum
    
   enum ColorType: String {
       case red = "red"      // 紅色
       case green = "green"  // 綠色
       case blue = "blue"    // 藍色
       
       var sliderMaxValue: Float {
           return 255.0              // Slider的最大值為 255
       }
       
       var defaultSliderValue: Float {
           return 255.0              // Slider的默認值為 255
       }
       
       var color: UIColor {
           switch self {
           case .red:
               return UIColor.red    // 紅色對應的 UIColor
           case .green:
               return UIColor.green  // 綠色對應的 UIColor
           case .blue:
               return UIColor.blue   // 藍色對應的 UIColor
           }
       }
   }
    // MARK: - Variables
    
    let colors = ["Black", "Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Magenta", "Purple", "Brown", "Pink", "BluePurple", "White"]
    
    // 用來存儲顏色名稱和對應的 RGB 值的字典
    let colorValues: [String: (CGFloat, CGFloat, CGFloat)] = [
        "Black": (0, 0, 0),
        "Red": (1, 0, 0),
        "Orange": (1, 0.647, 0),
        "Yellow": (1, 1, 0),
        "Green": (0, 1, 0),
        "Cyan": (0, 1, 1),
        "Blue": (0, 0, 1),
        "Magenta": (1, 0, 1),
        "Purple": (0.5, 0, 0.5),
        "BluePurple": (0.25, 0.25, 1),
        "Brown": (0.7, 0.4, 0.3),
        "Pink": (1, 0.5, 0.75),
        "White": (1, 1, 1)
    ]
    
    // MARK: - LifeCycle
    
    // viewDidLoad 是 UIViewController 的一個生命週期方法，它會在視圖加載後自動調用
    override func viewDidLoad()
    {
        super.viewDidLoad() // 調用父類的 viewDidLoad 方法
        
        setupUI()           // 初始化 UI
        setupDelegates()    // 初始化 delegates
        updateColorView()   // 更新顏色顯示
        updateControls()    // 更新控制元件的狀態（例如，是否啟用Slider）
    }
    
    // MARK: - UI Settings
    
    // 初始化整個 UI
    func setupUI() {
        // 使用自定義的 setupColorUI 方法初始化各個顏色的 UI
        setupColorUI(type: .red,
                     slider: redSlider,
                     valueField: redValue,
                     switchButton: redSwitch)
        setupColorUI(type: .green,
                     slider: greenSlider,
                     valueField: greenValue,
                     switchButton: greenSwitch)
        setupColorUI(type: .blue,
                     slider: blueSlider,
                     valueField: blueValue,
                     switchButton: blueSwitch)
        
        // 設置調色板（palatte）的邊界和圓角
        palatte.layer.borderWidth = 5
        palatte.layer.cornerRadius = 20
        palatte.layer.borderColor = UIColor.black.cgColor
        
        // 設置十六進制顏色碼（hexTextField）的文字對齊方式
        hexTextField.textAlignment = .center
        
        // 對 alphaSlider（透明度Slider）進行旋轉
        alphaSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        
        // 設置 imageView 的初始圖片
        imageView.image = UIImage(named: "p1")
        
        // 設置 alphaSlider 的初始值
        alphaSlider.value = 1
        
        // 將某些視圖元件帶到前景，以確保它們在其他元件之上
        view.bringSubviewToFront(redValue)
        view.bringSubviewToFront(greenValue)
        view.bringSubviewToFront(blueValue)
        view.bringSubviewToFront(palatte)
    }

    // 這個方法用於初始化單個顏色的 UI
    func setupColorUI(type: ColorType,
                      slider: UISlider,
                      valueField: UITextField,
                      switchButton: UISwitch) {
        // 使用 Enum 中的 color 屬性來設置開關和Slider的顏色
        switchButton.onTintColor = type.color
        slider.minimumTrackTintColor = type.color
        
        // 設置文字欄位的文字顏色和對齊方式
        valueField.textColor = .white
        valueField.textAlignment = .center
        
        // 設置Slider的最大值和文字欄位的初始值
        slider.maximumValue = type.sliderMaxValue
        valueField.backgroundColor = .clear
        valueField.text = "\(Int(type.defaultSliderValue))"
    }

    // 設置 delegates
    func setupDelegates() {
        redValue.delegate = self
        greenValue.delegate = self
        blueValue.delegate = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
    }
    
    // 這個函數定義了 UIPickerView 的組件（components）數量。
    // 在這個例子中，我們只有一個組件，用於顯示顏色列表。
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // 這個函數定義了每個組件有多少行（rows）。
    // 我們使用 `colors` 陣列的元素數量作為行數。
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }

    // 這個函數提供了每一行的標題（title）。
    // 標題是從 colors 陣列中取出的，對應於當前的行索引。
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }

    // 這個函數會在用戶選擇 UIPickerView 的某一行後被調用。
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 從 colors 陣列中取出用戶選擇的顏色名稱。
        let colorName = colors[row]
        
        // 調用 updateSelectedColor 方法以更新 UI，該方法會根據選擇的顏色名稱來設置相應的顏色。
        updateSelectedColor(colorName)
        
        // 調用 updateColorView 和 updateControls 方法以更新顏色顯示和控制元件。
        updateColorView()
        updateControls()
    }

    // 這個函數用於更新 slider、textField 和 switch 的值和顏色
    func updateColorComponents(_ slider: UISlider,
                               _ textField: UITextField,
                               _ colorSwitch: UISwitch,
                               color: UIColor) {
        var value: Float = 0.0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        // 使用 UIColor 的 getRed:green:blue:alpha 方法來取得傳入顏色的 RGB 和 alpha 成分
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // 根據傳入的 slider（紅、綠或藍）來決定用哪個顏色成分來更新值
        switch slider {
            case redSlider:
                value = Float(red * 255.0)
            case greenSlider:
                value = Float(green * 255.0)
            case blueSlider:
                value = Float(blue * 255.0)
            default:
                break
        }
        
        // 進行 UI 更新。設置 slider 的值，textField 的文字，以及 switch 的狀態。
        slider.value = value
        textField.text = "\(-Int(value) + 255)"
        colorSwitch.isOn = value > 0
        setSliderMinimumTrackColor(from: color, slider: slider)
        
    }

    // 這個函數用於根據選擇的顏色名稱來更新顏色成分
    func updateSelectedColor(_ colorName: String) {
        // 使用 guard 語句來確保 colorName 存在於 colorValues 字典中。
        // 如果不存在，則直接返回。
        guard let colorTuple = colorValues[colorName] else { return }
        
        // 印出選擇的顏色和對應的 RGB 值（主要用於調試）
        print("Selected color: \(colorName), RGB: \(colorTuple)")  // Debug line
        
        // 根據選擇的顏色生成紅、綠、藍三個顏色對象
        let redColor = UIColor(red: colorTuple.0,
                               green: 0,
                               blue: 0,
                               alpha: 1.0)
        let greenColor = UIColor(red: 0,
                                 green: colorTuple.1,
                                 blue: 0,
                                 alpha: 1.0)
        let blueColor = UIColor(red: 0,
                                green: 0,
                                blue: colorTuple.2,
                                alpha: 1.0)
        
        // 使用先前定義的 `updateColorComponents` 函數來更新紅、綠、藍的 UI 元件
        updateColorComponents(redSlider, redValue, redSwitch, color: redColor)
        updateColorComponents(greenSlider, greenValue, greenSwitch, color: greenColor)
        updateColorComponents(blueSlider, blueValue, blueSwitch, color: blueColor)
        
        // 更新 slider 的最小軌道顏色
        redSlider.minimumTrackTintColor = UIColor(red: colorTuple.0, green: 0, blue: 0, alpha: 1.0)
        greenSlider.minimumTrackTintColor = UIColor(red: 0, green: colorTuple.1, blue: 0, alpha: 1.0)
        blueSlider.minimumTrackTintColor = UIColor(red: 0, green: 0, blue: colorTuple.2, alpha: 1.0)
    }

    
    // 這個函數負責更新顯示的顏色和相關 UI 元件
    func updateColorView() {
        // 初始化 RGB 顏色成分為 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        

        // 如果紅色 switch 開啟，則根據紅色 slider 的值更新紅色成分
        if redSwitch.isOn { red = CGFloat(redSlider.value / 255) }
        // 如果綠色 switch 開啟，則根據綠色 slider 的值更新綠色成分
        if greenSwitch.isOn { green = CGFloat(greenSlider.value / 255) }
        // 如果藍色 switch 開啟，則根據藍色 slider 的值更新藍色成分
        if blueSwitch.isOn { blue = CGFloat(blueSlider.value / 255) }

        // 根據以上成分創建新的顏色
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        // 設定調色盤的背景顏色為新顏色
        palatte.backgroundColor = newColor

        // 轉換 RGB 值為 16 進制，並顯示在 hexTextField 中
        let redInt = Int(redSlider.value)
        let greenInt = Int(greenSlider.value)
        let blueInt = Int(blueSlider.value)
        let hexString = String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        hexTextField.text = hexString

        // 設定 hexTextField 的背景顏色為新顏色
        hexTextField.backgroundColor = newColor

        // 計算亮度，用於決定 hexTextField 的文字顏色應該是黑色還是白色
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        if brightness < 0.5 {
            hexTextField.textColor = UIColor.white
        } else {
            hexTextField.textColor = UIColor.black
        }

        // 設定顯示單一顏色成分的 view 的背景顏色
        let redColor = UIColor(red: red, green: 0, blue: 0, alpha: 1.0)
        redView.backgroundColor = redColor

        let greenColor = UIColor(red: 0, green: green, blue: 0, alpha: 1.0)
        greenView.backgroundColor = greenColor

        let blueColor = UIColor(red: 0, green: 0, blue: blue, alpha: 1.0)
        blueView.backgroundColor = blueColor
        
        // 使用過渡動畫來更新調色盤的背景顏色
        UIView.transition(with: palatte,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: { self.palatte.backgroundColor = newColor },
                          completion: nil)
    }
    
    // 用於根據指定的顏色類型（紅、綠、藍）來更新對應的 slider 和 textField
    func updateSliderAndTextField(type: ColorType) {
        var slider: UISlider!  // 用來儲存相對應的 slider
        var textField: UITextField!  // 用來儲存相對應的 textField
        
        // 根據指定的顏色類型來設定 slider, textField 和 color
        switch type {
        case .red:
            slider = redSlider
            textField = redValue
        case .green:
            slider = greenSlider
            textField = greenValue
        case .blue:
            slider = blueSlider
            textField = blueValue
        }

        // 讀取 slider 的值並更新 textField 的顯示
        let value = slider.value
        textField.text = "\(-Int(value) + 255)"
        // 更新 slider 的最小軌道顏色
        setSliderMinimumTrackColor(from: type.color, slider: slider)
    }

    // 用於直接更新指定的 slider 和 textField
    func updateSliderAndTextField(slider: UISlider,
                                  textField: UITextField,
                                  value: Float,
                                  color: UIColor) {
        // 設定 slider 的值
        slider.value = value
        // 更新 textField 的顯示
        textField.text = "\(-Int(value) + 255)"
        // 設定 slider 的最小軌道顏色
        setSliderMinimumTrackColor(from: color, slider: slider)
    }

    // 用於根據 switch 的狀態來啟用或禁用對應的 slider
    func updateControls() {
        // 如果紅色 switch 是開的，紅色 slider 就啟用；否則禁用
        redSlider.isEnabled = redSwitch.isOn
        // 如果綠色 switch 是開的，綠色 slider 就啟用；否則禁用
        greenSlider.isEnabled = greenSwitch.isOn
        // 如果藍色 switch 是開的，藍色 slider 就啟用；否則禁用
        blueSlider.isEnabled = blueSwitch.isOn
    }

    
    // 當 textField 編輯完成後會呼叫這個方法
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 檢查 textField 的文字是否存在和能否轉換為 Float
        guard let text = textField.text, let value = Float(text) else {
            textField.text = "0"  // 如果不存在或不能轉換，則設定為 "0"
            return
        }
        
        // 將值限制在 0 到 255 之間
        let clampedValue = min(max(0, value), 255)
        
        // 更新 textField 的顯示
        textField.text = "\(Int(clampedValue))"
        
        // 根據哪個 textField 被編輯，來更新對應的 slider
        switch textField {
        case redValue:
            redSlider.value = clampedValue
        case greenValue:
            greenSlider.value = clampedValue
        case blueValue:
            blueSlider.value = clampedValue
        default:
            break
        }
        
        // 更新顏色顯示視圖
        updateColorView()
    }

    // 用於更新 UI 以反映選中的顏色
    func updateUIForSelectedColor(name: String) {
        // 嘗試從顏色字典中取得選中顏色的 RGB 值
        guard let colorTuple = colorValues[name] else { return }
        
        // 更新各個 slider 的值
        redSlider.value = Float(colorTuple.0 * 255)
        greenSlider.value = Float(colorTuple.1 * 255)
        blueSlider.value = Float(colorTuple.2 * 255)
        
        // 更新顏色顯示視圖
        updateColorView()
    }
    
    // 定義一個函數來設置 Slider 的 minimumTrackTintColor
    func setSliderMinimumTrackColor(from color: UIColor, slider: UISlider) {
        
        // 宣告四個變數用來存儲紅色、綠色、藍色和透明度的數值
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // 使用 getRed 函數來獲取傳入的顏色的 RGB 和透明度數值
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // 將獲得的 RGB 數值存儲為一個 tuple（元組），方便後續使用
        let colorComponents = (red: red, green: green, blue: blue)

        // 使用 switch 來根據不同的 RGB 數值做不同的操作
        switch colorComponents {
        case (1, 0, 0):  // 如果是紅色
            // 根據 slider 的值計算新的紅色組件數值
            let newRed = CGFloat(slider.value / 255)
            // 生成新的 UIColor
            let newColor = UIColor(red: newRed, green: 0, blue: 0, alpha: 1.0)
            // 設置 slider 的 minimumTrackTintColor
            slider.minimumTrackTintColor = newColor
            
        case (0, 1, 0):  // 如果是綠色
            // 根據 slider 的值計算新的綠色組件數值
            let newGreen = CGFloat(slider.value / 255)
            // 生成新的 UIColor
            let newColor = UIColor(red: 0, green: newGreen, blue: 0, alpha: 1.0)
            // 設置 slider 的 minimumTrackTintColor
            slider.minimumTrackTintColor = newColor
            
        case (0, 0, 1):  // 如果是藍色
            // 根據 slider 的值計算新的藍色組件數值
            let newBlue = CGFloat(slider.value / 255)
            // 生成新的 UIColor
            let newColor = UIColor(red: 0, green: 0, blue: newBlue, alpha: 1.0)
            // 設置 slider 的 minimumTrackTintColor
            slider.minimumTrackTintColor = newColor
            
        default:  // 如果不是以上三種顏色
            // 不做任何事情
            break
        }
    }


    // MARK: - IBAction

    // 當 switch 的狀態改變時，這個方法會被觸發
    @IBAction func didChangeSwitchValue(_ sender: UISwitch) {
        // 更新顏色顯示視圖
        updateColorView()
        // 更新控制元件（尤其是 sliders）的狀態
        updateControls()
    }
    
    // 當任何一個 slider 的值改變時，這個方法會被觸發
    @IBAction func SliderChange(_ sender: UISlider) {
        var type: ColorType!  // 用於儲存顏色類型（紅、綠、藍）
        var textField: UITextField!  // 用於儲存對應的 textField

        // 根據觸發這個方法的 slider，設定顏色類型和對應的 textField
        switch sender {
        case redSlider:
            type = .red
            textField = redValue
        case greenSlider:
            type = .green
            textField = greenValue
        case blueSlider:
            type = .blue
            textField = blueValue
        default:
            break
        }

        // 獲取對應的顏色和 slider 值
        let color = type.color
        let value = sender.value

        // 更新 slider 和 textField 的狀態
        updateSliderAndTextField(slider: sender, textField: textField, value: value, color: color)

        // 更新顯示的顏色
        updateColorView()
    }

    // 當 textField 中的文本改變時，這個方法會被觸發
    @IBAction func TextChange(_ sender: UITextField) {
        // 更新所有顏色的 slider 和 textField
        textFieldDidEndEditing(redValue)
        textFieldDidEndEditing(greenValue)
        textFieldDidEndEditing(blueValue)
        
        // 更新顯示的顏色
        updateColorView()
    }

    // 當點擊 "Random" 按鈕時，這個方法會被觸發
    @IBAction func random(_ sender: Any) {
        // 生成隨機的顏色值
        let randomValues = [
            "red": Float.random(in: 0...255),
            "green": Float.random(in: 0...255),
            "blue": Float.random(in: 0...255)
        ]

        // 設置 slider 對應到的顏色類型
        let sliders: [ColorType: UISlider] = [
            .red: redSlider,
            .green: greenSlider,
            .blue: blueSlider
        ]

        // 更新所有 slider 的值
        for (colorType, slider) in sliders {
            if let value = randomValues[colorType.rawValue] {
                slider.value = value
                updateSliderAndTextField(type: colorType)
            }
        }

        // 更新 switch 的狀態
        redSwitch.isOn = redSlider.value > 0
        greenSwitch.isOn = greenSlider.value > 0
        blueSwitch.isOn = blueSlider.value > 0

        // 更新顯示的顏色和控件狀態
        updateColorView()
        updateControls()
    }

    // 當點擊 "Reset" 按鈕時，這個方法會被觸發
    @IBAction func reset(_ sender: Any) {
        // 將 colorPicker 的選中行設為第一行（通常為 "Black"）
        colorPicker.selectRow(0, inComponent: 0, animated: true)

        // 更新選中的顏色（通常為第一個顏色，也就是 "Black"）
        updateSelectedColor(colors.first!)
        
        // 更新顯示的顏色和控件狀態
        updateColorView()
        updateControls()
    }

    // 當點擊 "Convert" 按鈕時，這個方法會被觸發
    @IBAction func convert(_ sender: Any) {
        // 從 hexTextField 獲取文本，並去除 "#" 字符
        let hexString = hexTextField.text!.trimmingCharacters(in: ["#"])
        
        // 檢查是否是有效的 6 位數的十六進制字符串
        if hexString.count == 6 {
            // 解析紅、綠、藍的十六進制值
            let redHexValue = Int(hexString.prefix(2), radix: 16)
            let greenHexValue = Int(hexString.dropFirst(2).prefix(2), radix: 16)
            let blueHexValue = Int(hexString.dropFirst(4).prefix(2), radix: 16)
            
            // 更新 slider 的值和 textField 的文本
            redSlider.value = Float(redHexValue ?? 0)
            greenSlider.value = Float(greenHexValue ?? 0)
            blueSlider.value = Float(blueHexValue ?? 0)
            
            redValue.text = "\(-(redHexValue ?? 0)+255)"
            greenValue.text = "\(-(greenHexValue ?? 0)+255)"
            blueValue.text = "\(-(blueHexValue ?? 0)+255)"
            
            // 根據紅、綠、藍值來設定 switch 的狀態
            redSwitch.isOn = (redHexValue ?? 0) != 0
            greenSwitch.isOn = (greenHexValue ?? 0) != 0
            blueSwitch.isOn = (blueHexValue ?? 0) != 0
            
            // 更新 slider 的最小軌道顏色
            redSlider.minimumTrackTintColor = UIColor(red: CGFloat(redSlider.value / 255),
                                                      green: 0,
                                                      blue: 0,
                                                      alpha: 1.0)
            greenSlider.minimumTrackTintColor = UIColor(red: 0,
                                                        green: CGFloat(greenSlider.value / 255),
                                                        blue: 0,
                                                        alpha: 1.0)
            blueSlider.minimumTrackTintColor = UIColor(red: 0,
                                                       green: 0,
                                                       blue: CGFloat(blueSlider.value / 255),
                                                       alpha: 1.0)
    
            // 更新顯示的顏色
            updateColorView()
        
        } else {
            // 如果不是有效的十六進制，清空 textField
            hexTextField.text = ""
        }
    }

    // 當 alphaSlider 的值改變時，這個方法會被觸發
    @IBAction func alphaChange(_ sender: UISlider) {
        // 獲取 alphaSlider 的值
        let alphaValue = CGFloat(sender.value)
        
        // 更新 palatte 的透明度
        palatte.alpha = alphaValue
    }
}
