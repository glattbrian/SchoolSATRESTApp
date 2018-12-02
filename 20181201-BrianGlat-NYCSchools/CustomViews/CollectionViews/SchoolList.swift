//
//  SchoolList.swift
//  20181201-BrianGlat-NYCSchools
//
//  Created by Brian Glatt on 12/1/18.
//  Copyright © 2018 Brian. All rights reserved.
//

//Display schools in collection view
import UIKit

class SchoolList : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var schoolCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return schools.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! SchoolCell
        
        let school = schools.object(at: indexPath.item) as! School;
        
        cell.button.setTitle(String(school.school_name), for: .normal);
        
        cell.button.addTarget(self, action: #selector(self.viewDetails), for: .touchUpInside)
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight/8)
    }
    
    @objc func viewDetails(sender: UIButton!)
    {
        controller!.schoolDataView.setUpData(school: indexedSchools.object(forKey: (sender.titleLabel?.text)!) as! School);
        controller?.displaySchoolData();
    }
    

}
