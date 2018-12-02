//
//  SchoolDataView.swift
//  20181201-BrianGlat-NYCSchools
//
//  Created by Brian Glatt on 12/1/18.
//  Copyright © 2018 Brian. All rights reserved.
//

import UIKit

class SchoolDataView : UIView
{
    var currentSchool : School?
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var mathScore: UILabel!
    @IBOutlet weak var readingScore: UILabel!
    @IBOutlet weak var writingScore: UILabel!
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    @IBOutlet weak var overView: UITextView!
    
    //Loads SAT Data
    func setUpData(school : School)
    {
        currentSchool=school;
        schoolName.text=currentSchool?.school_name;
        overView.text=currentSchool?.overview_paragraph;
        loadingLabel.isHidden=false;
        notFoundLabel.isHidden=true;
        
        let s="https://data.cityofnewyork.us/resource/734v-jeq5.json?dbn="+currentSchool!.dbn;
        guard let url = URL(string: s) else
        {
            self.dataNotFound();
            return;
        };
        
        _ = URLSession.shared.dataTask(with: url)
        {
            (data, response, error) in
            
            if let data = data
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]]
                        else
                    {
                        self.dataNotFound()
                        return;
                    }
                    
                    //School is not in SAT database
                    if(json.count<=0)
                    {
                        self.dataNotFound()
                    }
                    else
                    {
                        DispatchQueue.main.async()
                        {
                            self.displayData(data: json[0])
                        }
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }.resume()
    }
    
    //Display that data was not found
    func dataNotFound()
    {
        DispatchQueue.main.async()
        {
            self.notFoundLabel.isHidden=false;
        }
    }
    
    //If data found displays
    func displayData(data : [String : Any])
    {
        loadingLabel.isHidden=true;
        overView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false);
        mathScore.text=data["sat_math_avg_score"] as? String;
        readingScore.text=data["sat_critical_reading_avg_score"] as? String;
        writingScore.text=data["sat_writing_avg_score"] as? String;
    }
}
