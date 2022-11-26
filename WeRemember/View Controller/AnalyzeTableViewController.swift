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
        view.addSubview(show_donutChart())
    
    }
    
    func show_donutChart() -> UIView{
        let percentages:[CGFloat] = [20, 50, 30]
        var start:CGFloat = 270
        let view = UIView()
        for percentage in percentages{
            //比例圓環
            let end = start + percentage
            let percentageCircularPath = UIBezierPath(arcCenter: CGPoint(x:200, y: 150), radius: 100, startAngle: CGFloat.pi/180*start/100*360, endAngle: CGFloat.pi/180*end/100*360, clockwise: true)
            let percentageCircularLayer = CAShapeLayer()
            percentageCircularLayer.path = percentageCircularPath.cgPath
            percentageCircularLayer.strokeColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            percentageCircularLayer.fillColor = UIColor.clear.cgColor
            percentageCircularLayer.lineWidth = 50

            //將圓環疊加成為UIView
            view.layer.addSublayer(percentageCircularLayer)
            //將percentage startAngle起始點更新
            start = end
        }
        return view
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

