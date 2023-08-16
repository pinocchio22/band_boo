//
//  ViewController.swift
//  band_instagram
//
//  Created by t2023-m0056 on 2023/08/08.
//

import UIKit

class MainVc: UIViewController {
    
    private var customCollectionView: CustomCollectionView!
    private let data = Data()
    var popularList = PopularMovieList.popularMovieList.movieList
    var filteredList = [MovieInfo]()
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    enum MovieDownloadError: Error {
        case invalidURLString
        case invalidServerResponse
    }
    
    var myPicker: UIPickerView?
    var pickerTextField: UITextField?
    let pickerList = ["인기순", "평점 평균"]
    
    let sortBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        setSortBtn()
        setSearchControllerUI()
        setPickerView()
        
        
        Task {
            do {
                PopularMovieList.popularMovieList.movieList = try await APIManager().getMovie()
                popularList = PopularMovieList.popularMovieList.movieList
                customCollectionView.reloadData()
            }
            catch MovieDownloadError.invalidURLString {
                print("movie error - invalidURLString")
            } catch MovieDownloadError.invalidServerResponse {
                print("movie error - invalidServerResponse")
            }
            
            //            guard let movies = try? await APIManager().getMovie() else { return }
            //            PopularMovieList.popularMovieList.movieList = movies
        }
//        APIManager().getMovie { movies in
//            PopularMovieList.popularMovieList.movieList = movies
//            self.customCollectionView.reloadData()
//        }
    }
    
    // MARK: collectionView
    func configureCollectionView() {
        customCollectionView = CustomCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        // false - AutoLayout을 따르겠다(AutoLayout)
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        customCollectionView.backgroundColor = .white
        
        // subview 추가
        self.view.addSubview(customCollectionView)
        
        // 제약 조건 설정
        //        customCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        customCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        customCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        customCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    func registerCollectionView() {
        customCollectionView.register(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifier")
    }
    
    func collectionViewDelegate() {
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
    }
    
    // MARK: alignBtn
    func setSortBtn() {
        let sortBtn = UIButton()
        
        var MenuItem: [UIAction] {
            return [
                UIAction(title: "인기순", image: nil, handler: { (_) in
                    // 인기순 정렬
                    self.popularList.sort{ $0.popularity > $1.popularity }
                    self.customCollectionView.reloadData()
                }),
                UIAction(title: "평점순", image: nil, handler: { (_) in
                    // 평점순 정렬
                    self.popularList.sort{ $0.voteAverage > $1.voteAverage }
                    self.customCollectionView.reloadData()
                }),
            ]
        }
        
        var sortMenu: UIMenu {
            return UIMenu(title: "", image: UIImage(systemName: "ellipsis.circle"), identifier: nil, options: [], children: MenuItem)
        }
        
        self.view.addSubview(sortBtn)
        sortBtn.backgroundColor = .white
        sortBtn.setTitleColor(.black, for: .normal)
        sortBtn.setTitle("정렬", for: .normal)
        
        sortBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //        sortBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //        sortBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        //        sortBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        sortBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        //        sortBtn.bottomAnchor.constraint(equalTo: customCollectionView.topAnchor, constant: -10).isActive = true
        
        let sortBtnConstraints: [NSLayoutConstraint] = [
            sortBtn.heightAnchor.constraint(equalToConstant: 40),
            sortBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            sortBtn.widthAnchor.constraint(equalToConstant: 100),
            sortBtn.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            sortBtn.bottomAnchor.constraint(equalTo: customCollectionView.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(sortBtnConstraints)
        
        sortBtn.layer.cornerRadius = 10
        sortBtn.layer.borderWidth = 0.5
        
        sortBtn.addTarget(self, action: #selector(setSort), for: .touchUpInside)
        
        sortBtn.menu = sortMenu
        sortBtn.showsMenuAsPrimaryAction = true
    }
    
    @objc
    func setSort() {
        print("setSortTap")
        showPickerView()
    }
    
    
    // MARK: searchBar
    private var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()
    
    
    func setSearchControllerUI() {
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        self.navigationItem.searchController = searchController
    }
    
    // MARK: pickerView
    func setPickerView() {
        myPicker = UIPickerView()
        myPicker!.delegate = self
        self.pickerTextField?.inputView = myPicker
    }
    
    func showPickerView() {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolBar.backgroundColor = .darkGray
        self.pickerTextField?.inputAccessoryView = toolBar
        
        let BarButton = UIBarButtonItem()
        BarButton.title = "Done"
        BarButton.target = self
        BarButton.action = #selector(DoneBtn)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, BarButton], animated: true)
    }
    
    @objc func DoneBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
}

// MARK: collectionView extension
extension MainVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let itemSpacing: CGFloat = 10
        let cellWidth: CGFloat = (width - (sectionInsets.left + sectionInsets.right) - (itemSpacing * 2)) / 3
        let cellHeigt: CGFloat = ((width - (sectionInsets.left + sectionInsets.right) - (itemSpacing * 2)) / 3) + 40
        return CGSize(width: cellWidth, height: cellHeigt)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = customCollectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! CollectionViewCell
        cell.movieImg.clipsToBounds = true
        if let image = (URL(string: popularList[indexPath.row].posterPath)) {
            cell.movieImg.load(url: image)
        } else {
            cell.movieImg.image = UIImage(systemName: "photo")
        }
        cell.movieName.text = popularList[indexPath.row].title
        cell.movieRate.text = String(popularList[indexPath.row].voteAverage)
        cell.moviePopular.text = String(popularList[indexPath.row].popularity)
        return cell
    }
}

// MARK: searchBar extension
extension MainVc: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = true
        self.customCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.lowercased() else { return }
        Task {
            do {
                PopularMovieList.popularMovieList.movieList = try await APIManager().searchMovie(text)
            }
            catch MovieDownloadError.invalidURLString {
                print("movie error - invalidURLString")
            } catch MovieDownloadError.invalidServerResponse {
                print("movie error - invalidServerResponse")
            }
            popularList = PopularMovieList.popularMovieList.movieList
            customCollectionView.reloadData()
        }
    }
    
    //    // 서치바에서 검색버튼을 눌렀을 때 호출
    //        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //            dismissKeyboard()
    //
    //        }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.text = ""
        self.searchController.searchBar.resignFirstResponder()
        self.customCollectionView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.customCollectionView.reloadData()
    }
    
    // 서치바 키보드 내리기
    func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: imageView extension
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

// MARK: pickerview extension
extension MainVc: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
}

extension MainVc: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.pickerList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerList[row]
    }
}
