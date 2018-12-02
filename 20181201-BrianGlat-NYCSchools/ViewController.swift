//
//  ViewController.swift
//  20181201-BrianGlat-NYCSchools
//
//  Created by Brian Glatt on 12/1/18.
//  Copyright © 2018 Brian. All rights reserved.
//

import UIKit

//Stores data for particular school
struct School
{
    let dbn : String;
    let school_name : String;
    let overview_paragraph : String;
    
    init(j : [String : Any])
    {
        dbn = j["dbn"] as! String;
        school_name = j["school_name"] as! String;
        overview_paragraph = j["overview_paragraph"] as! String;
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var screenView: UIScrollView!
    
    @IBOutlet weak var schoolList: SchoolList!
    
    @IBOutlet weak var schoolDataView: SchoolDataView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    var loadFinished = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=self;
        loadAllSchools();
    }
    func loadAllSchools()
    {
        //Prepares URL
        guard let url = URL(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json") else
        {
            notFoundLabel.isHidden=false;
            return
        };
        
        _ = URLSession.shared.dataTask(with: url)
        {
            (data, response, error) in
            
            if let data = data
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else
                    {
                        DispatchQueue.main.async()
                        {
                            //Formatting error
                            self.notFoundLabel.isHidden=false;
                        }
                        return
                    }
                    //Prepares data to be displayed
                    for s in json
                    {
                        let school=School(j : s);
                        schools.add(School(j : s));
                        indexedSchools.setObject(school, forKey: school.school_name as NSCopying)
                    }
                    
                    //Loads and displays
                    DispatchQueue.main.async()
                    {
                        self.loadingLabel.isHidden=true;
                        self.schoolList.schoolCollection.reloadData();
                    }
                }
                catch
                {
                    print(error)
                }
            }
            }.resume()
    }
    
    func displaySchoolData()
    {
        screenView.setContentOffset(CGPoint.init(x: screenWidth, y: 0), animated: true);
        
    }
    @IBAction func back(_ sender: Any)
    {
        screenView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true);
    }
    
}

