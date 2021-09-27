//
//  HeaderReusableView.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 23/09/21.
//

import UIKit

//Enum to check the heart's state
enum Heart {
    case empty
    case filled
}

class HeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var likeIconOutlet: UIImageView!
    
    //Number of likes
    var likes = 0 {
        didSet {
            likesLabel.text = "\(likes) Likes"
        }
    }
    //Variable to track the heart status
    var heartState = Heart.empty
    
    //Name of SFSymbols to be used
    let emptyHeartIcon = "heart"
    let filledHeartdIcon = "heart.fill"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Same color as collection view background
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        //Set movieImage to nil
        movieImage.image = nil
       
        
    }
    //MARK: - Header SetUp
    func setUpHeader(title: String, posterPath: String, voteCount: Int, popularity: Double) {
        setTitle(title)
        setImage(posterPath)
        setLikes(voteCount)
        setViews(popularity)
    }
    //MARK: - Set Title Label
    func setTitle(_ title: String?) {
        if let movieTitle = title{
            titleLabel.text = movieTitle
        }
        
    }
    
    //MARK: - Set Movie Image
    func setImage(_ image: String?){
        
        //If there's an image already, doesn't need to fetch again
        if movieImage.image != nil{
            return
        }
        //Fetch the image from the given string
        if let imageURL = image{
            
            let url = URL(string: imageURL)
            if url != nil{
                guard let imageData = try? Data(contentsOf: url!)
                
                else {
                    return
                }
                //Set the image to the one that was fetched
                movieImage.image = UIImage(data: imageData)
            }
            //If it was not possible to fetch, initialize with an empty image
            else{
                movieImage.image = nil
            }
           
        }
        
    }
    
    //MARK: - Set Likes Label
    func setLikes(_ voteCount: Int?){
        if voteCount != nil{
            likes = voteCount!
            //likesLabel.text = "\(likes) likes"
            
        }
    }
    
    //MARK: - Set Views Label
    func setViews(_ popularity: Double?){
        if let views = popularity{
            viewsLabel.text = "\(views) Views"
        }
    }
    
   
    
    
    //MARK: - Like Button Pressed
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        //Prevents user from touching multiple times
        sender.isUserInteractionEnabled = false
        
        //If heart is empty
        if heartState == .empty{
            //Update the heart icon to filled
            sender.setBackgroundImage(UIImage(systemName: self.filledHeartdIcon), for: .normal)
            //Start the floating heart animation
            startAnimation(sender)
        }
        
        //If heart is filled
        else{
            //Update heart icon to empty
            sender.setBackgroundImage(UIImage(systemName: self.emptyHeartIcon), for: .normal)
            //Remove the user's like
            self.likes -= 1
            //Update heartState to empty
            self.heartState = .empty
            //Allows user to interact again
            sender.isUserInteractionEnabled = true
        }
        
    }
    //MARK: - Animations
    
    //Floating Heart Animation
    fileprivate func startAnimation(_ sender: UIButton) {
        //Get the position of the button
        let heartInitialPos = (x: sender.frame.origin.x, y: sender.frame.origin.y)
        //Create an UIImage, with the heart symbol
        let heartImage = UIImage(systemName: filledHeartdIcon)
        let animatedHeartImageView = UIImageView(image: heartImage)
        animatedHeartImageView.tintColor = .white
        //Set initial position to button's position
        animatedHeartImageView.frame = CGRect(x: heartInitialPos.x, y: heartInitialPos.y, width: 25, height: 25)
        animatedHeartImageView.contentMode = .scaleAspectFit
        //Add to corresponding view
        gradientView.addSubview(animatedHeartImageView)
        
        //Start the animation
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        //Animate the heart to the like icon center position
                        animatedHeartImageView.frame.origin.x = self!.likeIconOutlet.frame.midX - self!.likeIconOutlet.frame.size.width / 2
                        animatedHeartImageView.frame.origin.y = self!.likeIconOutlet.frame.midY - self!.likeIconOutlet.frame.size.height / 2
                        
                       }, completion: {_ in
                        //When animation ends, start the heart beat animation
                        self.heartBeatAnimation(sender: sender, animatedHeartImageView: animatedHeartImageView )
                        
                        
                       })
    }
    
    // Heart Beat animation
    fileprivate func heartBeatAnimation(sender: UIButton, animatedHeartImageView: UIImageView) {
        //Remove the floating heart from superview
        animatedHeartImageView.removeFromSuperview()
        //Update number of likes
        self.likes += 1
        //Update heart state to filled
        self.heartState = .filled
        //Allows user to interact again
        sender.isUserInteractionEnabled = true
        // Starts heartBeat animation
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.likeIconOutlet.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            self.likeIconOutlet.transform = CGAffineTransform.identity
                        }
                       })
    }
    
    
}
