//
//  MainViewController.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 22/09/21.
//

import UIKit

//private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MovieManagerDelegate, SimilarMoviesDelegate, GenresDelegate, NoConnectionDelegate {
    
    
   
    
    //Header Identifier
    fileprivate let headerId = "headerID"
    
   
    
    var movieManager = MovieManager()
    var similarMoviesManager = SimilarMoviesManager()
    var genresManager = GenresListManager()
   
    //Variable that contains a dictionary to get the corresponding genre
    var genresDict = GenresList()
    
    //Variables that will contain the Data to show
    var similarMovies = [SimilarMovie]()
    var movie = Movie(title: "", id: 0, posterPath: "", voteCount: 0, popularity: 0)
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set the Collection View Properties
        setCollectionViewProperties()
        //Set the delegates
        setDelegates()
        //Get the data
        getData()
    }
    
    //MARK: - Set Collection View Porperties
    func setCollectionViewProperties(){
        
        //Register Header NIB
        collectionView.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        //Layout Settings
        collectionView.contentInsetAdjustmentBehavior = .never
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
           
            layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            layout.headerReferenceSize = .init(width: view.frame.width, height: 525)
        }
    }
    
    //MARK: - Set Delegates
    func setDelegates() {
        movieManager.delegate = self
        similarMoviesManager.delegate = self
        genresManager.delegate = self
        
    }
    
    //MARK: - Fetch data from API
    func getData(){
        
        let dispatchGroup = DispatchGroup()
        
        //Get the Genres
        dispatchGroup.enter()
        genresManager.performRequest{ (_,_) in
            dispatchGroup.leave()
            
        }
        
        //Get the Movie Data
        dispatchGroup.enter()
        movieManager.performRequest{(_,_) in
            
            dispatchGroup.leave()
        }
        
        //Get Similar Movies Data
        dispatchGroup.enter()
        similarMoviesManager.getSimilarMovies{(_,_) in
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            print("Finished")
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.isHidden = false
        })
        
    }
   //MARK: - Status Bar - Light Content
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: - Genres Delegate
    func didGetGenres(_ genresManager: GenresListManager, genres: [Genre]) {
         genresDict = GenresList(list: genres)
    }
    
    //MARK: - Movie Manager Delegate
    func didUpdateMovie(_ movieManager: MovieManager, movie: Movie) {
        self.movie = movie
    }
    
    //MARK: - Similar Movies Delegate
    func didGetSimilarMovies(_ similarMoviesManager: SimilarMoviesManager, similarMovies: [SimilarMovie]) {
        self.similarMovies = similarMovies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            print("RELOADED")
        }
       
    }
    //MARK: - No Connection Delegate
    func fetchDataAgain(_ noConnectionViewController: NoConnectionViewController) {
        print("Data Again")
        getData()
    }
    //MARK: - Errors
    func didFailWithError(error: Error) {
        print("ERRRRRROOOOOOOOOORRRR")
        
        //Create a try again screen
        DispatchQueue.main.async {
            self.tryAgainScreen()
        }
       
    }
    
    
    //MARK: - Try Again Screen
    func tryAgainScreen(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "show", sender: self)
        }
    }
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noConnection = segue.destination as! NoConnectionViewController
        noConnection.main = self
        noConnection.delegate = self
    }
    
    //MARK: - Header Settings
    //Set up header properties
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderReusableView
        //Set header properties
        header.setUpHeader(title: movie.title, posterPath: movie.posterPath, voteCount: movie.voteCount, popularity: movie.popularity)
        
        return header
    }
    //Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 525)
    }

    // MARK: UICollectionViewDataSource

    // Similar Movie Cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimilarMovieCell
        
        //Get the corresponding similar movie
        var similarMovie = similarMovies[indexPath.row]
        
        //Get the image if there's none
        if similarMovie.posterImage == nil{
            //Get image
            similarMovie.getImage(from: movie.posterPath)
        }
        
        //Set the image and title
        cell.moviePosterImage.image = similarMovie.posterImage
        cell.movieTitleLabel.text = similarMovie.originalTitle
        
        //Create the description
        let description = createDescription(similarMovie: similarMovie)
                
        //Set the description
        cell.movieDescriptionLabel.text = description
        
        return cell
    }
    //Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }

    //Cell layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 150)
    }
    
    //MARK: - Create Description Function
    func createDescription(similarMovie: SimilarMovie) -> String {
        //Create the description string, with release year and genres
        var description = ""
        //Separate the year, month and date of release date
        let releaseDate = similarMovie.releaseDate.split(separator: "-")
        //Get the year from release date
        description += releaseDate[0]
        
        //Iterate all genres of the movie
        for (index, genre) in similarMovie.genres.enumerated(){
            //Adds a space
            description += " "
            //Adds the corresponding genre
            description += genresDict.getGenre(genreIndex: genre) ?? ""
            
            //If it's not the last item of the array, add a comma
            if similarMovie.genres.count - 1 > index{
                description += ","
            }
        }
        return description
    }
    
    
}
