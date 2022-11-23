//
//  AnalyzeTableViewController.swift
//  WeRemember
//
//  Created by Alice on 2022/11/17.
//

import UIKit
import Charts

class AnalyzeTableViewController: UITableViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var allExpenseItems = [Finance]()
    
    override func viewWillAppear(_ animated: Bool) {
       

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //生成項目數據 DataEntry
    //以支出類別為Entry
    func setChartView() {
        //生成項目數據 DataEntry
        let pieChartDataEntries = Spend.expenseCategories.map({(category)->PieChartDataEntry in
            return PieChartDataEntry(value: Double(calculateSum(category: category)), label: category.rawValue)
        })
        
        
        //設定項目 DataSet
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        
        //設定項目顏色
        dataSet.colors = Spend.expenseCategories.map({ (category)->UIColor in
            return UIColor(named: "\(category)") ?? UIColor.white
        })
       
        //點選後突出距離
        dataSet.selectionShift = 10
        
        //圓餅分隔間距
        dataSet.sliceSpace = 5
        
        //設定資料 Data
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DigitValueFormatter())
        pieChartView.data = data
        
        //動畫
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
            
        
        
        
        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Spend.expenseCategories.count
        }
    
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Categories"
        }
        
        
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AnalyzeTableViewCell.self)", for: indexPath) as? AnalyzeTableViewCell else { return UITableViewCell() }
             
             let category = Spend.expenseCategories[indexPath.row]
             //cell.categoryImageView.image = UIImage(named: "\(category.rawValue)")
             cell.categoryLabel.text = category.rawValue
             cell.amountLabel.text = "$ \(numberFormatter(amount: calculateSum(category: category)))"
             
             return cell
         }
    
        func calculateSum(category:ExpenseCategory)->Int32 {
            let totalAmount = allExpenseItems.reduce(0,{if $1.category == category.rawValue{
                                                    return $0+Int($1.amount) };return $0})
            return Int32(totalAmount)
        }
    
        func dateFormatter(date:Date)-> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, MMM d, yyyy"
            let dateStr = dateFormatter.string(from: date)
            return dateStr
            
        }
    
        func numberFormatter(amount:Int32)->String{
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            return formatter.string(from: NSNumber(value:amount))!
        }
    
    
         
        
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
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    class DigitValueFormatter: NSObject, ValueFormatter {
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let valueWithoutDecimalPart = String(format: "%.1f%%", value)
            return valueWithoutDecimalPart
        }
    }

