//
//  MainViewController.swift
//  WeRemember
//
//  Created by Alice on 2022/11/14.
//

import UIKit

class MainViewController: UIViewController {
    
    
    var finances = [Finance]() {
        didSet {
            //儲存資料
            Finance.saveFinances(finances)
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //將資料讀進一開始的畫面
        if let data = Finance.loadFinances() {
            self.finances = data
        }
    }
    
    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        //取得由Add畫面傳回的expense
        if let source = unwindSegue.source as? AddTableViewController,
           let finance = source.finance {
            
            
            //判斷資料是新增/編輯，有indexPath 為資料編輯，無indexPath 為資料新增
            if let indexPath = tableView.indexPathForSelectedRow?.row {
                finances[indexPath] = finance
            } else {
                
                //由新增的方式進入下一頁
                finances.insert(finance, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.reloadData()
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "ShowAddTable" {
//            if let addTable = segue.destination as? AddTableViewController,
//               let targetController = addTable.AddTableViewController,
//               let row = tableView.indexPathForSelectedRow?.row{
//                targetController.finance = finances[row]
//                print("給資料")
//            }
//        }else{
//            if let addTable = segue.destination as? AddTableViewController,
//               let targetController = addTable.AddTableViewController {
//                targetController.selectedDate = dateFormatter(date: datePicker.date)
//                print("給date \(dateFormatter(date: datePicker.date))")
//            }
//        }
//    }

    
    
    @IBAction func dateAction(_ sender: Any) {
    }
    
    
    @IBSegueAction func showDate(_ coder: NSCoder) -> AddTableViewController? {
        let controller = AddTableViewController(coder: coder)
        controller?.showDateTextField = datePicker.date
        return controller
    }
    
    
    /*
    @IBSegueAction func editExpenseItem(_ coder: NSCoder) -> AddTableViewController? {
        let controller = AddTableViewController(coder: coder)
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.finance = finances[row]
        }
        return controller
    }
    */
    
    
    //將要修改的資料傳到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddTableViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            controller.finance = finances[row]
        }
    }
    
    
    func numberFormatter(amount: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let amountString = formatter.string(from: NSNumber(value: amount))!
        return amountString
    }
    
    func dateFormatter(date:Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ExpenseTableViewCell.self)", for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        let expenseItem = finances[indexPath.row]
        print(cell)
        cell.amountLabel?.text = numberFormatter(amount: expenseItem.amount)
        cell.accountLabel?.text = expenseItem.account
        cell.memoLabel?.text = expenseItem.memo
        cell.categoryLabel?.text = expenseItem.category
        cell.dateLabel?.text = dateFormatter(date: expenseItem.date)
        
//        if expenseItem.isExpense == true {
//            cell.categoryLabel.text = expenseItem.category
//            //cell.categoryImageView.image = UIImage(named: "\(expenseItem.category!)")
//            cell.amountLabel.backgroundColor = UIColor.clear
//            cell.amountLabel.textColor = UIColor.black
//        }else{
//            cell.categoryLabel.text = expenseItem.category
//            //cell.categoryImageView.image = UIImage(named: expenseItem.category ?? "")
//            cell.amountLabel.backgroundColor = UIColor.systemGreen
//            cell.amountLabel.textColor = UIColor.white
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let expenseAmount = finances.reduce(0, {if $1.isExpense==true { return $0+Int($1.amount)};return $0})
        let incomeAmount = finances.reduce(0, {if $1.isExpense==false { return $0+Int($1.amount)};return $0})
        if finances.isEmpty{
            return nil
        }else{
            return "Expense: \(expenseAmount) Income: \(incomeAmount) Total: \(expenseAmount-incomeAmount)"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        finances.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
}
