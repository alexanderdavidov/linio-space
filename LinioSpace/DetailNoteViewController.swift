//
//  DetailNoteViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 08.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit

class DetailNoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: properties
    var station: Station?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40 //загрузка автоматического подбора высоты ячейки
        tableView.rowHeight = UITableViewAutomaticDimension //загрузка автоматического подбора высоты ячейки
        imageView.image = UIImage(data: station!.image as! Data)
        tableView.tableFooterView = UIView(frame: CGRect.zero) // убираем строки, которые не заполняем данными
        title = station!.nameStation // в название в детали заметки устанавливаем название станции метро
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailNoteTableViewCell
        switch indexPath.row {
        case 0:
            cell.firstLabel.text = "Город"
            cell.secondLabel.text = station!.city
        case 1:
            cell.firstLabel.text = "Название станции"
            cell.secondLabel.text = station!.nameStation
        case 2:
            cell.firstLabel.text = "Дополнительная информация"
            cell.secondLabel.text = station!.addInformation
        default:
            break
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
