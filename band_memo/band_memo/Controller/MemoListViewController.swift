//
//  MemoListViewController.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/03.
//

import UIKit

class MemoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var addBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var memoTable: UITableView!
    @IBOutlet weak var toolbarCount: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var folderName = ""
    var memoList =  [MemoData(title: "", content: "", date: "", isChecked: false)]
    var filteredList = [MemoData]()
    var currentIndex = 0
    
    var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "갤러리로 보기", image: nil, handler: { (_) in
                self.performSegue(withIdentifier: "showCollection", sender: nil)
            }),
            UIAction(title: "메모 선택", image: nil, handler: { (_) in
            }),
        ]
    }
    
    var demoMenu: UIMenu {
        return UIMenu(title: "", image: UIImage(systemName: "ellipsis.circle"), identifier: nil, options: [], children: menuItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTable.delegate = self
        memoTable.dataSource = self
        
        memoTable.sectionHeaderTopPadding = 2
        
        self.toolbarCount.title = "\(self.memoList.count)개의 메모"
        
        // search bar
        setupSearchController()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.updateNotification(_:)),name:NSNotification.Name("updateTable"),object: nil)
        
        // complete 에서는 실행 x
        if folderName != "complete" {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            longPressGesture.minimumPressDuration = 0.5
            memoTable.addGestureRecognizer(longPressGesture)
        } else {
            addBtnOutlet.isEnabled = false
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: nil, primaryAction: nil, menu: demoMenu)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredList = memoList.filter { $0.content.contains(text) }
        memoTable.reloadData()
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.memoTable)
        let indexPath = self.memoTable.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            // 동작
            let alert = UIAlertController(title: "완료 목록", message: "완료 하셨습니까?", preferredStyle: .alert)
            let sucess = UIAlertAction(title: "확인", style: .default){ ok in
                print("확인 버튼이 눌렸습니다.")
                if !self.isFiltering {
                    self.memoList[indexPath!.row].isChecked = true
                    MemoService.service.createMemo("complete", self.memoList[indexPath!.row])
                } else {
                    self.memoList[indexPath!.row].isChecked = true
                    MemoService.service.createMemo("complete", self.filteredList[indexPath!.row])
                }
                MemoService.service.deleteMemo(self.folderName, indexPath!.row)
                MemoService.service.saveUserDefaults()
                NotificationCenter.default.post(name: Notification.Name("updateTable"), object: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .destructive){ cancel in
                print("취소 버튼이 눌렸습니다.")
            }
            alert.addAction(sucess)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
    }
    
    @objc func updateNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            // 이 부분 수정
            if !self.isFiltering {
                self.memoList = MemoService.service.folderList.data[self.folderName]!
                self.memoTable.reloadData()
                self.toolbarCount.title = "\(self.memoList.count)개의 메모"
            } else {
                self.filteredList = MemoService.service.folderList.data[self.folderName]!
                self.memoTable.reloadData()
                self.toolbarCount.title = "\(self.filteredList.count)개의 메모"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("updateTable"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        if !self.isFiltering {
            cell.memoName.text = memoList[indexPath.row].title
            cell.memoContent.text = memoList[indexPath.row].content
            cell.memoDate.text = memoList[indexPath.row].date
            setImage(cell.memoFolder, folderName)
        } else {
            cell.memoName.text = filteredList[indexPath.row].title
            cell.memoContent.text = filteredList[indexPath.row].content
            cell.memoDate.text = filteredList[indexPath.row].date
            setImage(cell.memoFolder, folderName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredList.count : self.memoList.count
    }
    
    // section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FolderData.memoSection[section]
    }
    
    // 스와이프 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemoService.service.deleteMemo(folderName, indexPath.row)
            memoTable.reloadData()
            memoList = MemoService.service.folderList.data[folderName]!
            memoTable.deleteRows(at: [indexPath], with: .fade)
            self.toolbarCount.title = "\(String(self.memoList.count))개의 메모"
        }
    }
    
    // 화면 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        performSegue(withIdentifier: "ShowEditMemo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditMemo" {
            if segue.destination is EditMemoViewController {
                let vc = segue.destination as? EditMemoViewController
                if !self.isFiltering {
                    vc?.memo = self.memoList[currentIndex]
                    vc?.index = currentIndex
                    vc?.folderName = folderName
                } else {
                    vc?.memo = self.filteredList[currentIndex]
                    vc?.index = currentIndex
                    vc?.folderName = folderName
                }
            }
        } else if segue.identifier == "BtnToShowMemo" {
            if segue.destination is EditMemoViewController {
                let vc = segue.destination as? EditMemoViewController
                vc?.memo = MemoData(title: "", content: "", date: "", isChecked: false)
                vc?.folderName = folderName
            }
        } else if segue.identifier == "showCollection" {
            let vc = segue.destination as? CollectionViewController
            if !self.isFiltering {
                vc?.memoList = self.memoList
                vc?.currentIndex = currentIndex
                vc?.folderName = folderName
            } else {
                vc?.memoList = self.filteredList
                vc?.currentIndex = currentIndex
                vc?.folderName = folderName
            }
        }
    }
    
    @IBAction func addMemoBtn(_ sender: Any) {
        // 메모추가 화면으로 전환
        performSegue(withIdentifier: "BtnToShowMemo", sender: nil)
    }
    
    func setImage(_ label: UILabel, _ text: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "folder")
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: text))
        label.attributedText = attributedString
    }
}
