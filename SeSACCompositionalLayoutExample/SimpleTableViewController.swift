//
//  ViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["어린이", "어른이", "오린이", "오른이"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 14이상에서 사용가능하며 컬렉션뷰에서 주로 사용됨
        
        // 적용시키기 위한 셀을 생성하는 코드
        let cell = UITableViewCell()
        
        // 셀에 적용시킬 코드
        // 적용시키려면 var를 사용해야한다.
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] // textLabel 대체
        content.secondaryText = "어른이" // detailTextLabel
        
        // 셀에 적용시키는 코드
        cell.contentConfiguration = content
        return cell
    }

}

