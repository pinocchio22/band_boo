//
//  MemoListViewController.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var toolbarCount: UIBarButtonItem!
    @IBOutlet weak var memoCollection: UICollectionView!
    
    var memoList = [MemoData(title: "", content: "", date: "", isChecked: false)]
    var folderName = ""
    var currentIndex = 0
    var service = MemoService.service
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoCollection.delegate = self
        memoCollection.dataSource = self
        
        self.toolbarCount.title = "\(self.memoList.count)개의 메모"
        
        let nibName = UINib(nibName: "MemoCollectionCell", bundle: nil)
        memoCollection.register(nibName, forCellWithReuseIdentifier: "MemoCollectionCell")
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.updateNotification(_:)),name:NSNotification.Name("updateTable"),object: nil)
    }
    
    @objc func updateNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            // 이 부분 수정
            self.memoList = MemoService.service.folderList.data[self.folderName]!
            self.memoCollection.reloadData()
            self.toolbarCount.title = "\(self.memoList.count)개의 메모"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memoCollection.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("updateTable"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memoCollection.dequeueReusableCell(withReuseIdentifier: "MemoCollectionCell", for: indexPath) as! MemoCollectionCell
        cell.collectionName.text = memoList[indexPath.row].content
        cell.collectionDate.text = memoList[indexPath.row].date
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoList.count
    }
    
    // 화면 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
        performSegue(withIdentifier: "ShowEditMemo", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTable" {
            if segue.destination is MemoListViewController {
                let vc = segue.destination as? MemoListViewController
                vc?.memoList = self.memoList
                vc?.currentIndex = currentIndex
                vc?.folderName = folderName
            }
        } else if segue.identifier == "BtnToShowMemo" {
            if segue.destination is EditMemoViewController {
                let vc = segue.destination as? EditMemoViewController
                vc?.memo = MemoData(title: "", content: "", date: "", isChecked: false)
                vc?.folderName = "defaults"
            }
        } else if segue.identifier == "ShowEditMemo" {
            let vc = segue.destination as? EditMemoViewController
            vc?.memo = memoList[currentIndex]
            vc?.folderName = folderName
            vc?.index = currentIndex
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let itemSpacing: CGFloat = 10
        let cellWidth: CGFloat = (width - (sectionInsets.left + sectionInsets.right) - (itemSpacing * 2)) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
