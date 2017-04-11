//
//  NewStationTableViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 08.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit

class NewStationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stationNameTextField: UITextField!
    @IBOutlet weak var addInformationTextField: UITextField!
    
    // MARK: action
    @IBAction func saveButtonSelect(_ sender: UIBarButtonItem) {
        if cityTextField.text == "" || stationNameTextField.text == "" || addInformationTextField.text == "" {
            let ac = UIAlertController(title: "Внимание!", message: "Заполните все текстовые поля", preferredStyle: .alert)
            let acAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
            ac.addAction(acAction)
            present(ac, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let station = Station(context: context)
                station.city = cityTextField.text
                station.nameStation = stationNameTextField.text
                station.addInformation = addInformationTextField.text
                if let image = imageView.image {
                    station.image = UIImagePNGRepresentation(image) as NSData?
                }
                
                do {
                    try context.save()
                    print("Сохранение удалось") 
                } catch let error as NSError {
                    print("Не удалось сохранить данные \(error) \(error.userInfo)")
                }
            }
            performSegue(withIdentifier: "unwindSegueFromNewStation", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // определяем  действие когда выбираем конкретное изображение
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill // режим отображения изображения
        imageView.clipsToBounds = true // обрезка по рамке
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .camera)
            })
            let photoAction = UIAlertAction(title: "Фото Галерея", style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            })
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(photoAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true) // снимаем выделение ячейки
    }
    
    func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // обрезка по краям выбираемой фотографии
            imagePicker.sourceType = source // попадаем на камеру или в библиотеку
            self.present(imagePicker, animated: true, completion: nil) // представляем picker
        }
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
