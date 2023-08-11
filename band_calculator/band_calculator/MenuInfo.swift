//
//  Dummy.swift
//  band_calculator
//
//  Created by t2023-m0056 on 2023/07/26.
//

import UIKit

class FirstCell {
    var pic: UIImage
    var name: String
    var description: String
    var btn: String
    
    init(pic: UIImage, name: String, description: String, btn: String) {
        self.pic = pic
        self.name = name
        self.description = description
        self.btn = btn
    }
    
    static var firstCell = [
        FirstCell(pic: UIImage(systemName: "airplane")!, name: "최진훈", description: "Apple ID, iCloud, 미디어 및 구입", btn: ">")
    ]
}

class SecondCell {
    var icon: UIImage
    var name: String
    var text: String
    
    init(icon: UIImage, name: String, text: String) {
        self.icon = icon
        self.name = name
        self.text = text
    }
    
    static var secondCell = [
        SecondCell(icon: UIImage(systemName: "airplane")!, name: "에어플레인 모드", text: ""),
        SecondCell(icon: UIImage(systemName: "wifi")!, name: "Wi-Fi", text: "KT_GIGA_Mesh_C9B6"),
        SecondCell(icon: UIImage(systemName: "b.circle")!, name: "Bluetooth", text: "연결 안 됨"),
        SecondCell(icon: UIImage(systemName: "cellularbars")!, name: "셀룰러", text: ""),
        SecondCell(icon: UIImage(systemName: "personalhotspot")!, name: "개인용 핫스팟", text: "끔")
    ]
    
    static var thirdCell = [
        SecondCell(icon: UIImage(systemName: "light.beacon.min")!, name: "알림", text: ""),
        SecondCell(icon: UIImage(systemName: "headphones.circle")!, name: "사운드 및 햅틱", text: ""),
        SecondCell(icon: UIImage(systemName: "slash.circle")!, name: "집중 모드", text: ""),
        SecondCell(icon: UIImage(systemName: "timer")!, name: "스크린타임", text: ""),
        SecondCell(icon: UIImage(systemName: "timer")!, name: "스크린타임", text: ""),
        SecondCell(icon: UIImage(systemName: "timer")!, name: "스크린타임", text: ""),
        SecondCell(icon: UIImage(systemName: "timer")!, name: "스크린타임", text: ""),
        SecondCell(icon: UIImage(systemName: "timer")!, name: "스크린타임", text: ""),
    ]
}
