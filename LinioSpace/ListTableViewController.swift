//
//  ListTableViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 10.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit
import CloudKit

class ListTableViewController: UITableViewController {
    
    // MARK: properties
    var stations: [CKRecord] = [] //массив станций
    let publicDataBase = CKContainer.default().publicCloudDatabase // идем до публичной бд icloud
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getCloudRecords() // подргужаем наши записи
    }
    
    // MARK: getCloudRecords
    // получаем записи с icloud
    func getCloudRecords() {
        let predicate = NSPredicate(value: true) // создаем предикат
        let query = CKQuery(recordType: "Station", predicate: predicate) // создаем query
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                print(error!)
                return }
            if let records =  records {
                self.stations = records
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                } // выдаем запись или ошибку
            }
        }
        
    }
    
    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 // возвращаем одну секцию
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stations.count // выдаем то количество строк, сколько элеметов в нашем массиве stations
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // dequeueReusableCell по indexPath
        let station = stations[indexPath.row] // добираемся до строки
        cell.textLabel?.text = station.object(forKey: "name") as? String // записываем как String
        cell.textLabel?.numberOfLines = 5 // количество линий может быть до 5
        cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10.0) // устанавливаем шрифт
        if let image = station.object(forKey: "image") {
            let image = image as! CKAsset
            let data = try? Data(contentsOf: image.fileURL)
            if let data = data {
                cell.imageView?.image = UIImage(data: data)
            } // выводим изображение
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // убираем выделение
    }
}
