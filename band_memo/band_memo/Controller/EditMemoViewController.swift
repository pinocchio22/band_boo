//
//  EditMemoViewController.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class EditMemoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var editTextView: UITextView!
    
    var service: MemoService?
    var index = -1
    var folderName = ""
    var memo: MemoData?
    var newMemo = MemoData(title: "", content: "", date: "", isChecked: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextView.delegate = self
        editTextView.text = memo?.content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("updateTable"), object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        newMemo.content = textView.text!
        newMemo.date = getCurrentDateTime()
        if textView.text.count < 10 {
            newMemo.title = textView.text
        } else {
            newMemo.title = (textView.text as NSString).substring(to: 10)
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        if newMemo.content != "" {
            if index == -1 {
                // 생성
                MemoService.service.createMemo(folderName, newMemo)
            } else {
                // 추가
                MemoService.service.updateMemo(folderName, index, newMemo)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
