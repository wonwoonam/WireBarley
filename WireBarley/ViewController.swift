//
//  ViewController.swift
//  WireBarley
//
//  Created by Won Woo Nam on 2020/12/16.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var data = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
    
    let warningView = WarningView()
    
    var responseDict: NSDictionary!
    var currencyArray = [String]()
    var countryArray = ["KRW", "JPY", "PHP"]
    var parameter: [String : String] = [:]
    var KRW = 0
    var JPY = 0
    var PHP = 0
    
    
    var tempTotal = ""
    var dataRow = 0
    
    var picker = UIPickerView()
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var finalAmount: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData {
            self.getCurrArray()
            self.country.text = self.data[0]
            self.currency.text = self.addCommaOverThsnd(initial: self.currencyArray[0])
        }
        
        getDate()
    }
    
    
    func getData(completionHandler:  @escaping () -> ()){
        parameter = ["access_key": "a5f6d00c3c2dad0d243eb8ec34e211c6", "currencies": "KRW,JPY,PHP"]
        let url = "http://api.currencylayer.com/live?access_key=a5f6d00c3c2dad0d243eb8ec34e211c6&format=1"
        
       
        AF.request(url, method: .get, parameters: parameter)
            .responseData { (response) in
                switch response.result {
                case .success(let result):
                    
                   
                    var temp = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject] as NSDictionary?
                    self.responseDict = temp!["quotes"] as! NSDictionary
                    print(self.responseDict)
                    
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
                completionHandler()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupTextFields()
        setupPicker()
        setupTapGestures()
        setupWarningView()
    }
    
    func getDate(){
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "ko_KR")
        self.time.text = dateFormatter.string(from: date)
    }
    
    func setupTapGestures(){
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)

        amount.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
       

        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        country.addGestureRecognizer(tap)
        country.isUserInteractionEnabled = true
    }
    
    func setupWarningView(){
        warningView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        warningView.popUpView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        warningView.extraButton.addTarget(self, action: #selector(self.clearPopup), for: .touchUpInside)
    }
    
    
    func setupPicker(){
        var pickerRect = picker.frame
        picker.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.height-pickerRect.height), size: CGSize(width: view.frame.width, height: picker.frame.height))
        picker.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        picker.delegate = self
        picker.dataSource = self
    }
    
    func setupTextFields() {
            let toolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                             target: self, action: #selector(doneButtonTapped))
            
            toolbar.setItems([flexSpace, doneButton], animated: true)
            toolbar.sizeToFit()
            
            amount.inputAccessoryView = toolbar
           
        }
        
    

    func getCurrArray(){
        currencyArray.append(roundDecimals(initial: (responseDict["USDKRW"] as! NSNumber).stringValue))
        currencyArray.append(roundDecimals(initial: (responseDict["USDJPY"] as! NSNumber).stringValue))
        currencyArray.append(roundDecimals(initial: (responseDict["USDPHP"] as! NSNumber).stringValue))
       
    }
    
    func roundDecimals(initial:String) -> String{
        var num = Double(initial)
        var rounded = Double(num!).rounded(toPlaces: 2)
        return String(rounded)
    }
    
    func calculateFinalAmount(){
        if amount.text == ""{
            return
        }
        var tempAmnt = Double(((amount.text)?.replacingOccurrences(of: ",", with: ""))!)
        var currency = Double(currencyArray[dataRow])
        
        var tempFinal = tempAmnt! * currency!
        print(tempFinal)
        finalAmount.text = "수취금액은 " + addCommaOverThsnd(initial: String(tempFinal)) + " " + countryArray[dataRow] + " 입니다"
    }
    
    
    func addCommaOverThsnd(initial:String) -> String{
        if (initial == ""){
            return ""
        }
        let largeNumber = Double(initial)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber!))
        return formattedNumber!
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if amount.text!.count > 14 {
            tempTotal = amount.text!
            return false
        }
        return true
    }
    
    
    //Functions about Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        country.text = data[row]
        currency.text = addCommaOverThsnd(initial: currencyArray[row])
        dataRow = row
        calculateFinalAmount()
        self.view.endEditing(true)
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    

    
    //Sender functions
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        var tempAmnt = Double(((amount.text)?.replacingOccurrences(of: ",", with: ""))!)
        
        if (tempAmnt == nil) || (tempAmnt == 0){
            amount.text = ""
            finalAmount.text = "금액을 입력해 주세요"
            view.endEditing(true)
            UIApplication.shared.keyWindow?.addSubview(self.warningView)
            picker.removeFromSuperview()
            return
        }
        else if (tempAmnt! > 10000) {
            amount.text = tempTotal
            calculateFinalAmount()
            view.endEditing(true)
            UIApplication.shared.keyWindow?.addSubview(self.warningView)
            picker.removeFromSuperview()
            return
        }
        amount.text = addCommaOverThsnd(initial: ((amount.text)?.replacingOccurrences(of: ",", with: ""))!)
        tempTotal = amount.text!
        calculateFinalAmount()
    }
    
    //Removes keyboard
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
            view.addSubview(picker)
    }

    //Removes picker
    @objc func dismissKeyboard() {
        picker.removeFromSuperview()
    }
    
    //Removes the warningView
    @objc func clearPopup(sender: UIButton!) {
        for eachView in UIApplication.shared.keyWindow!.subviews{
            if eachView.isKind(of: WarningView.self){
                eachView.removeFromSuperview()
            }
        }
    }
    
    @objc func doneButtonTapped() {
        picker.removeFromSuperview()
        view.endEditing(true)
    }
    

}


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
