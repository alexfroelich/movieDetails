//
//  CustomFlowLayout.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 25/09/21.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        let layoutAttributes = super.layoutAttributesForElements(in: rect) as [UICollectionViewLayoutAttributes]?
        
        let offset = collectionView!.contentOffset
        
        //Only if user is scrolling up
        if offset.y < 0{
            //Get the absolute value of offset
            let offsetY = abs(offset.y)
            
            for attributes in layoutAttributes!{
               
                //Check if it is header
                if let elementKind = attributes.representedElementKind{
                    if elementKind == UICollectionView.elementKindSectionHeader{
                        
                        var frame = attributes.frame
                        //Set the height
                        frame.size.height = max(0, headerReferenceSize.height + offsetY)
                        //Change origin position to compensate the new height
                        frame.origin.y = frame.minY - offsetY
                        
                        attributes.frame = frame
                        
                    }
                }
            }
        }
        
        return layoutAttributes
    }
    //MARK: - Invalidate Layout
    
    //Update the layout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
