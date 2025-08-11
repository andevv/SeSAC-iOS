//
//  MapViewController.swift
//  SeSAC7Week7
//
//  Created by Jack on 8/11/25.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
     
    private let mapView = MKMapView()
    private let viewModel = MapViewModel()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        bindViewModel()
    }
     
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "지도"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "메뉴",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
         
        view.addSubview(mapView)
         
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
         
        let seoulStationCoordinate = CLLocationCoordinate2D(latitude: 37.5547, longitude: 126.9706)
        let region = MKCoordinateRegion(
            center: seoulStationCoordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func bindViewModel() {
        // 레스토랑 목록이 바뀌면 어노테이션 갱신 후 영역 자동 맞춤
        viewModel.restaurants.bind({ [weak self] list in
            guard let self = self else { return }
            self.reloadAnnotations(with: list)
            self.fitAllAnnotations()
        })
    }

    @objc private func rightBarButtonTapped() {
        let alert = UIAlertController(title: "카테고리 선택", message: nil, preferredStyle: .actionSheet)

        RestaurantCategory.allCases.forEach { category in
            let action = UIAlertAction(title: category.rawValue, style: .default) { _ in
                self.viewModel.setCategory(category)
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
     
//    @objc private func rightBarButtonTapped() {
//        let alertController = UIAlertController(
//            title: "메뉴 선택",
//            message: "원하는 옵션을 선택하세요",
//            preferredStyle: .actionSheet
//        )
//        
//        let alert1Action = UIAlertAction(title: "얼럿 1", style: .default) { _ in
//            print("얼럿 1이 선택되었습니다.")
//        }
//        
//        let alert2Action = UIAlertAction(title: "얼럿 2", style: .default) { _ in
//            print("얼럿 2가 선택되었습니다.")
//        }
//        
//        let alert3Action = UIAlertAction(title: "얼럿 3", style: .default) { _ in
//            print("얼럿 3이 선택되었습니다.")
//        }
//        
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
//            print("취소가 선택되었습니다.")
//        }
//        
//        alertController.addAction(alert1Action)
//        alertController.addAction(alert2Action)
//        alertController.addAction(alert3Action)
//        alertController.addAction(cancelAction)
//         
//        present(alertController, animated: true, completion: nil)
//    }
    
    private func reloadAnnotations(with list: [Restaurant]) {
        mapView.removeAnnotations(mapView.annotations)

        let annotations: [MKPointAnnotation] = list.map { r in
            let ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2D(latitude: r.latitude, longitude: r.longitude)
            ann.title = r.name
            ann.subtitle = "\(r.category) · \(r.address)"
            return ann
        }
        mapView.addAnnotations(annotations)
    }
    
    private func fitAllAnnotations(edge: CGFloat = 40) {
        let anns = mapView.annotations
        guard !anns.isEmpty else { return }

        var zoomRect = MKMapRect.null
        anns.forEach { ann in
            let point = MKMapPoint(ann.coordinate)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(rect)
        }

        mapView.setVisibleMapRect(
            zoomRect,
            edgePadding: UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge),
            animated: true
        )
    }
}
 
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        print("어노테이션이 선택되었습니다.")
        print("제목: \(annotation.title ?? "제목 없음")")
        print("부제목: \(annotation.subtitle ?? "부제목 없음")")
        print("좌표: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
        
        // 선택된 어노테이션으로 지도 중심 이동
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("어노테이션 선택이 해제되었습니다.")
    }
}
