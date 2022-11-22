//
//  ExpenseTableViewCell.swift
//  WeRemember
//
//  Created by Alice on 2022/11/16.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
