//
//  PageViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 08.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // массивы
    var presentTextArray = ["-Просматривайте Фотографии Метро \n\n-Создавайте Актуальные Заметки \n\n-Делитесь Контентом с Друзьями", "Начать использовать приложение"]
    var imagesArray = ["nps.001", "ms"]
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: displayViewController
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else {return nil }
        guard index < presentTextArray.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        contentViewController.imageFile = imagesArray[index]
        contentViewController.presentText = presentTextArray[index]
        contentViewController.index = index
        return contentViewController
    }
    
    // pageViewController before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    // pageViewController after
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    // setViewControllers для VC
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: +1) {
            setViewControllers([contentVC], direction:  .forward, animated: true, completion: nil)
        }
    }
    
    
}
