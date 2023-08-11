//
//  MemoService.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/02.
//

import Foundation

class MemoService {
    static let service = MemoService()
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var folderList = FolderData(data: ["iCloud":[MemoData(title: "1번", content: "1번 내용", date: "8월", isChecked: false)]])
    
    init() {
        folderList = loadUserDefaults()
    }
    
    //save userDefaults
    func saveUserDefaults() {
        if let encoded = try? encoder.encode(folderList) {
            print("type: \(type(of: encoded))") //Data
            UserDefaults.standard.set(encoded, forKey: "Memo")
        }
    }
    
    //get userDefaults
    func loadUserDefaults() -> FolderData {
        if let data = UserDefaults.standard.object(forKey: "Memo") as? Data,
           let memo = try? decoder.decode(FolderData.self, from: data) {
            if memo.data.isEmpty {
                return self.folderList
            }
            return memo
        }
        return FolderData(data: ["iCloud":[], "defaults":[], "complete":[]])
    }
    
    //create memoList
    func createMemo(_ key: String, _ data: MemoData) {
        folderList.data[key]?.append(data)
        print(folderList.data.keys)
        saveUserDefaults()
    }
    
    //delete memoList
    func deleteMemo(_ key: String, _ index: Int) {
        folderList.data[key]?.remove(at: index)
        print(folderList.data)
        saveUserDefaults()
    }
    
    //update memoList
    func updateMemo(_ key: String, _ index: Int, _ data: MemoData) {
        folderList.data[key]?[index] = data
        saveUserDefaults()
    }
}
