//
//  MemoData.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class FolderData: Codable {
    var data: [String:Array<MemoData>]
    
    init(data: [String : Array<MemoData>]) {
        self.data = data
    }
        static var folderSection = ["폴더"]
        static var memoSection = ["memoSection"]
}

class MemoData: Codable {
    var title: String
    var content: String
    var date: String
    var isChecked: Bool
    
    init(title: String, content: String, date: String, isChecked: Bool) {
        self.title = title
        self.content = content
        self.date = date
        self.isChecked = isChecked
    }
}
