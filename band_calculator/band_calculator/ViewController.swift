//
//  ViewController.swift
//  band_calculator
//
//  Created by t2023-m0056 on 2023/07/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    // cell 연결
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.titleName.text = FirstCell.firstCell[indexPath.row].name
            cell.titleDisc.text = FirstCell.firstCell[indexPath.row].description
            cell.accessoryType = .disclosureIndicator
            return cell
            
        } else if indexPath.section == 1 {
            tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            
            tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            if indexPath.row == 0 {
                cell2.switchImage.image = SecondCell.secondCell[indexPath.row].icon
                cell2.switchName.text = SecondCell.secondCell[indexPath.row].name
                cell2.accessoryType = .none
                return cell2
                
            } else {
                cell1.menuImage.image = SecondCell.secondCell[indexPath.row].icon
                cell1.menuName.text = SecondCell.secondCell[indexPath.row].name
                cell1.menuText.text = SecondCell.secondCell[indexPath.row].text
                cell1.accessoryType = .disclosureIndicator
                return cell1
            }
        } else {
            tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell

            cell.menuImage.image = SecondCell.thirdCell[indexPath.row].icon
            cell.menuName.text = SecondCell.thirdCell[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    // section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // section 내부 cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return FirstCell.firstCell.count
        } else if section == 1 {
            return SecondCell.secondCell.count
        } else {
            return SecondCell.thirdCell.count
        }
    }
}

