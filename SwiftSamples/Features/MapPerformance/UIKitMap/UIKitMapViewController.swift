import UIKit
import SwiftUI
import MapKit
import CoreLocation

// ユーザーの位置情報
class UserAnnotation: NSObject, MKAnnotation {
  dynamic var coordinate: CLLocationCoordinate2D
  let id: String
  let name: String?

  init(coordinate: CLLocationCoordinate2D, id: String, name: String?) {
    self.coordinate = coordinate
    self.id = id
    self.name = name
  }

  // 位置情報変更メソッド
  func moveRandom() {
    let latOffset = Double.random(in: -0.01...0.01)
    let lonOffset = Double.random(in: -0.01...0.01)

    coordinate = CLLocationCoordinate2D(
      latitude: coordinate.latitude + latOffset,
      longitude: coordinate.longitude + lonOffset
    )
  }
}

//　オリジナルのAnnotationView
class UserAnnotationView: MKAnnotationView {
  static let reuseIdentifier = "UserAnnotationView"

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    // setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    // TODO: check
    canShowCallout = true

    let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    markerView.backgroundColor = .systemBlue
    markerView.layer.cornerRadius = 15
    markerView.layer.borderWidth = 2
    markerView.layer.borderColor = UIColor.white.cgColor
    
    let iconImageView = UIImageView(frame: markerView.bounds)
    iconImageView.image = UIImage(systemName: "pereson.fill")
    iconImageView.tintColor = .white
    iconImageView.contentMode = .center
    markerView.addSubview(iconImageView)

    self.addSubview(markerView)
  }
}

// マップの表示、位置情報の表示
class UIKitMapViewController: UIViewController, MKMapViewDelegate {
  private let mapView: MKMapView
  private var userAnnotations: [UserAnnotation] = []
  private var updateTimer: Timer?

  // 位置情報の更新を開始
  private let updateButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Start Location Updates", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 10
    return button
  }()

  init() {
    mapView = MKMapView(frame: .zero)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupUpdateButton()
    registerAnnotationView()
    addInitialUserAnnotations()
  }

  private func setupMapView() {
    view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    mapView.delegate = self
    mapView.mapType = .standard
    
    let tokyoCoordinate = CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
    let region = MKCoordinateRegion(
      center: tokyoCoordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    mapView.setRegion(region, animated: true)
  }

  private func setupUpdateButton() {
    view.addSubview(updateButton)
    updateButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      updateButton.widthAnchor.constraint(equalToConstant: 200),
      updateButton.heightAnchor.constraint(equalToConstant: 48)
    ])
    updateButton.addTarget(self, action: #selector(toggleLocationUpdates), for: .touchUpInside)
  }

  @objc private func toggleLocationUpdates() {
    if updateTimer == nil {
      startLocationUpdates()
      updateButton.setTitle("Stop Location Updates", for: .normal)
    } else {
      stopLocationUpdates()
      updateButton.setTitle("Start Location Updates", for: .normal)
    }
  }

  private func startLocationUpdates() {
    updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
      self?.updateUserLocations()
    })
  }

  private func stopLocationUpdates() {
    updateTimer?.invalidate()
    updateTimer = nil
  }

  private func registerAnnotationView() {
    mapView.register(
      UserAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: UserAnnotationView.reuseIdentifier
    )
  }

  private func addInitialUserAnnotations() {
    let users = [
      (id: "user1", name: "AAA", lat: 35.6762, lon: 139.6503),
      (id: "user2", name: "BBB", lat: 35.7100, lon: 139.8107),
      (id: "user3", name: "CCC", lat: 35.6895, lon: 139.6917)
    ]

    userAnnotations = users.map { user in
      let annotation = UserAnnotation(
        coordinate: CLLocationCoordinate2D(latitude: user.lat, longitude: user.lon),
        id: user.id,
        name: user.name
      )
      return annotation
    }
    mapView.addAnnotations(userAnnotations)
  }

  // annotationの位置を更新して再描画
  private func updateUserLocations() {
    userAnnotations.forEach { $0.moveRandom() }
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotations(userAnnotations)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
    guard !(annotation is MKUserLocation) else {
      return nil
    }
    
    guard let userAnnotation = annotation as? UserAnnotation else {
      return nil
    }

    guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UserAnnotationView.reuseIdentifier, for: annotation) as? UserAnnotationView else {
      return nil
    }
    
    annotationView.annotation = userAnnotation
    annotationView.canShowCallout = true
    annotationView.calloutOffset = CGPoint(x: -5, y: 5)
    
    let leftIconView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    leftIconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    annotationView.leftCalloutAccessoryView = leftIconView

    annotationView.detailCalloutAccessoryView = {
      let label = UILabel()
      label.text = userAnnotation.name ?? userAnnotation.id
      label.font = .systemFont(ofSize: 12)
      return label
    }()
    
    return annotationView
  }
}

struct UIKitMapRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    return UIKitMapViewController()
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}

struct UIKitMapView: View {
  var body: some View {
    UIKitMapRepresentable()
      .navigationTitle("UIKit Map")
  }
}
