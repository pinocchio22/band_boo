//
//  ViewController.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var folderTable: UITableView!
    
    var folderList = MemoService.service.folderList.data
    var folderNameList = [String]()
    var filteredNameList = [String]()
    var currentIndex = 0
    
    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderNameList = Array(folderList.keys)
        
        folderTable.delegate = self
        folderTable.dataSource = self
        
        folderTable.sectionHeaderTopPadding = 2
        
        // search bar
        setupSearchController()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.updateNotification(_:)),name: NSNotification.Name("updateTable"),object: nil)
    }
    
    private func setupSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchBar.placeholder = "검색(placeholder)"
        // 내비게이션 바는 항상 표출되도록 설정
        searchController.hidesNavigationBarDuringPresentation = false
        /// updateSearchResults(for:) 델리게이트를 사용을 위한 델리게이트 할당
        searchController.searchResultsUpdater = self
        /// 뒷배경이 흐려지지 않도록 설정
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredNameList = folderNameList.filter { $0.contains(text) }
        folderTable.reloadData()
    }
    
    @objc func updateNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            // 이 부분 수정
            self.folderList = MemoService.service.folderList.data
            self.folderTable.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "FolderCell", bundle: nil), forCellReuseIdentifier: "FolderCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.accessoryType = .disclosureIndicator
        if !self.isFiltering {
            cell.folderName.text = folderNameList[indexPath.row]
            cell.folderCount.text = String(folderList[folderNameList[indexPath.row]]!.count)
        } else {
            cell.folderName.text = filteredNameList[indexPath.row]
            cell.folderCount.text = String(folderList[filteredNameList[indexPath.row]]!.count)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredNameList.count : self.folderNameList.count
    }
    
    // section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FolderData.folderSection[section]
    }
    
    // 화면이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        performSegue(withIdentifier: "ShowMemo", sender: nil)
    }
    
    @IBAction func addMemobtn(_ sender: Any) {
        // 메모추가 화면으로 전환
        performSegue(withIdentifier: "BtnToShowMemo", sender: nil)
    }
    
    @IBAction func addFolderBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "폴더 추가", message: "폴더명을 입력하세요", preferredStyle: .alert)
        alert.addTextField()
        let sucess = UIAlertAction(title: "확인", style: .default){ ok in
            if alert.textFields![0].text != "" {
                MemoService.service.folderList.data[(alert.textFields?[0].text!)!] = []
                self.folderList = MemoService.service.folderList.data
                self.folderNameList = Array(self.folderList.keys)
                self.folderTable.reloadData()
                MemoService.service.saveUserDefaults()
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive){ cancel in
            
        }
        alert.addAction(sucess)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemo" {
            if segue.destination is MemoListViewController {
                let vc = segue.destination as? MemoListViewController
                if !self.isFiltering {
                    vc?.memoList = self.folderList[folderNameList[currentIndex]]!
                    vc?.folderName = folderNameList[currentIndex]
                } else {
                    vc?.memoList = self.folderList[filteredNameList[currentIndex]]!
                    vc?.folderName = filteredNameList[currentIndex]
                }
            }
        } else if segue.identifier == "BtnToShowMemo" {
            if segue.destination is EditMemoViewController {
                let vc = segue.destination as? EditMemoViewController
                vc?.memo = MemoData(title: "", content: "", date: "", isChecked: false)
                vc?.folderName = "defaults"
            }
        }
    }
}
