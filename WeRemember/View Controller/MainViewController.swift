//
//  MainViewController.swift
//  WeRemember
//
//  Created by Alice on 2022/11/14.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dateAction(_ sender: Any) {
    }
    
    
    @IBSegueAction func showDate(_ coder: NSCoder) -> AddTableViewController? {
        let controller = AddTableViewController(coder: coder)
        controller?.showDateTextField = datePicker.date
        return controller
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ""
    }
    
    
}
