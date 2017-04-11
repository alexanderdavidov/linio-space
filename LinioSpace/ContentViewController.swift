//
//  ContentViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 08.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    // MARK: outlets
    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pagesbutton: UIButton!
    
    // MARK: action
    @IBAction func pagesButtonSelect(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            let userDf = UserDefaults.standard
            userDf.set(true, forKey: "selected")
            userDf.synchronize() // записываем данные selected
            dismiss(animated: true, completion: nil)
        default:
            break
        } // работаем с кнопкой по начальным страницам
        
    }
    
    // MARK: properties
    var presentText = ""
    var imageFile = ""
    var index = 0
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagesbutton.layer.cornerRadius = 10
        pagesbutton.clipsToBounds = true
        pagesbutton.layer.borderWidth = 1
        pagesbutton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pagesbutton.layer.borderColor = (#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).cgColor
        switch index {
            case 0: pagesbutton.setTitle("Продолжить", for: .normal)
        case 1: pagesbutton.setTitle("Запуск", for: .normal)
        default: break
        }
        presentTextLabel.text = presentText
        imageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
