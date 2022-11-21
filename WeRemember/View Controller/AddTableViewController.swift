//
//  AddTableViewController.swift
//  WeRemember
//
//  Created by Alice on 2022/11/14.
//

import UIKit

class AddTableViewController: UITableViewController, UIPickerViewDelegate,  UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryList: UIPickerView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountList: UIPickerView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    var finance: Finance?
    var type = 0
    var AddTableViewController: AddTableViewController?
    var categoryListSelected = ""
    var accountListSelected = ""
    
    //支出與收入category
    var expenseCategory = ["飲食", "日常用品", "交通", "購物", "娛樂", "帳單", "其他"]
    var incomeCategory = ["薪資", "獎金", "投資", "禮金"]
    
    //支出與收入account
    var expenseAccount = ["現金", "銀行", "信用卡"]
    var incomeAccount = ["現金", "銀行", "信用卡"]
    
    
    // Picker的顯示狀態
    var isCategoryList = false
    var isAccountList = false
    var isPicShown = false
    
    // 包含Picker的Cell位置
    let categoryListCellIndexPath = IndexPath(row: 3, section: 0)
    let accountListCellIndexPath = IndexPath(row: 5, section: 0)
    let pictureCellIndexPath = IndexPath(row: 7, section: 0)
    
    
    //【MVC選日期在ATVC顯示】宣告儲存Date型別的屬性showDateTextField
    var showDateTextField = Date()
    

    
    //【點擊dateTextField彈跳出DatePicker】先宣告DatePicker
    let datePicker = UIDatePicker()
    var selectedDate:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //【MVC選日期在ATVC顯示】設定dateTextField顯示的格式
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .full
        dateformatter.locale = Locale(identifier: "default")
        
        //【MVC選日期在ATVC顯示】將date轉型為String，才能在dateTextField顯示
        let dateString = dateformatter.string(from: showDateTextField)
        dateTextField.text = dateString
        
        //Picker的Label一開始顯示的文字
        categoryLabel.text = expenseCategory[0]
        accountLabel.text = expenseAccount[0]
        
        
        memoTextField.returnKeyType = UIReturnKeyType.done
        
        
        updateUI()
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if amountTextField.text?.isEmpty == true{
            didNotCompleteAlertController()
            return false
        }else{
            return true
        }
    }
    
    
    func updateUI() {
        createDatePicker()
        
        //設定segmentControl
        typeSegmentedControl.setTitleTextAttributes([.foregroundColor:UIColor(named: "MainColor") ?? UIColor.black], for: .selected)
        typeSegmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.gray], for: .normal)
        
        //設定keyboard
        amountTextField.keyboardType = .numberPad
        
        if let finance = finance {
            amountTextField.text = finance.amount.description
            categoryLabel.text = finance.category
            memoTextField.text = finance.memo
            accountLabel.text = finance.account
        }
        
        
        
        
    }
    
    
    @IBAction func changeType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            finance?.isExpense = true
            finance?.category = Spend.expenseCategories.first!.rawValue
            categoryLabel.text = Spend.expenseCategories.first?.rawValue
        }else{
            finance?.isExpense = false
            finance?.category = Spend.incomeCategories.first!.rawValue
            categoryLabel.text = Spend.incomeCategories.first?.rawValue
            
        }
        
        
//        AddTableViewController?.type = typeSegmentedControl.selectedSegmentIndex
//        switch typeSegmentedControl.selectedSegmentIndex {
//        case 0:
//            AddTableViewController?.categoryLabel.text = AddTableViewController?.expenseCategory[0]
//            AddTableViewController?.accountLabel.text = AddTableViewController?.expenseAccount[0]
//        case 1:
//            AddTableViewController?.categoryLabel.text = AddTableViewController?.incomeCategory[0]
//            AddTableViewController?.accountLabel.text = AddTableViewController?.incomeAccount[0]
//        default:
//            break
//        }
//        AddTableViewController?.categoryList.dataSource = AddTableViewController
//        AddTableViewController?.accountList.dataSource = AddTableViewController
    }
    
    
    @IBAction func closeMemoKeyboard(_ sender: UITextField) {
    }
    
    
    
    
    
    @IBAction func changePic(_ sender: UIButton) {
        let imageSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍攝照片", style: .default) {
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "選擇圖片", style: .default) {
            (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        imageSourceAlert.addAction(cameraAction)
        imageSourceAlert.addAction(photoLibraryAction)
        
        present(imageSourceAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            cameraButton.setImage(image, for: .normal)
            cameraButton.contentMode = .scaleToFill
            cameraButton.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func dateFormatter(date:Date)->String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .full
        return dateFormatter1.string(from: date)
    }
    
    //【點擊dateTextField彈跳出DatePicker】設定DatePicker
    func createDatePicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = setDatePickerReturn()
    }
    
    //【點擊dateTextField彈跳出DatePicker】生成toolbar 加入Done按鍵
    func setDatePickerReturn() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,doneButton], animated: true)
        
        return toolBar
    }
    
    //【點擊dateTextField彈跳出DatePicker】Done按鍵設定
    @objc func selectDoneButton() {
        dateTextField.text = dateFormatter(date: datePicker.date)
        self.view.endEditing(true)
    }
    
    func didNotCompleteAlertController() {
        let controller = UIAlertController(title: "未填寫金額", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
   
    
    
    // MARK: - Picker view data source
    
    // Picker都有幾個滾輪？ 類別與帳戶都只有1個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 滾輪有幾列？依據不同滾輪和收支，回傳不同的列數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            
        case categoryList:
            if type == 0 {
                
                return expenseCategory.count
            } else {
                return incomeCategory.count
            }
            
        case accountList:
            if type == 0 {
                
                return expenseAccount.count
            } else {
                return incomeAccount.count
            }
            
        default:
            return 0
        }
    }
    
    
    // 每列顯示什麼？依據不同滾輪、收支和列數，回傳不同的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case categoryList:
            if type == 0 {
                
                return expenseCategory[row]
            } else {
                
                return incomeCategory[row]
            }
            
        case accountList:
            if type == 0 {
                
                return expenseAccount[row]
            } else {
                
                return incomeAccount[row]
            }
            
        default:
            return nil
        }
    }
    
    // 選擇列後要做什麼？依據不同滾輪、收支和所在列，顯示不同的資料
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case categoryList:
            if type == 0 {
                
                categoryLabel.text = expenseCategory[row]
            } else {
                
                categoryLabel.text = incomeCategory[row]
            }
            
        case accountList:
            if type == 0 {
                
                accountLabel.text = expenseAccount[row]
            } else {
                
                accountLabel.text = incomeAccount[row]
            }
        default:
            break
        }
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    
    //選擇列後要做什麼？依據不同位置展開包含Picker的Cell，並且修改Picker的顯示狀態、更新tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (categoryListCellIndexPath.section, categoryListCellIndexPath.row - 1):
            if isCategoryList == true {
                isCategoryList = false
            } else {
                isCategoryList = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (accountListCellIndexPath.section, accountListCellIndexPath.row - 1):
            if isAccountList == true {
                isAccountList = false
            } else {
                isAccountList = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    
    // 每列的高度？依據不同位置、Picker的顯示狀態，回傳相應的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case categoryListCellIndexPath:
            if isCategoryList == true {
                return 110
            } else {
                return 0
            }
            
        case accountListCellIndexPath:
            if isAccountList == true {
                return 110
            } else {
                return 0
            }
            
        case pictureCellIndexPath:
            if isPicShown == true {
                return 160
            } else {
                return 160
            }
            
        default:
            return UITableView.automaticDimension
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let saveAmount = Int(amountTextField.text!) ?? 0
        let saveMemo = memoTextField.text ?? ""
        let saveCategory = categoryListSelected
        let saveAccount = accountListSelected
        finance = Finance(date: datePicker.date, amount: saveAmount, category: saveCategory, account: saveAccount, memo: saveMemo, isExpense: true, additionalPic: Data())
    }

    

}
