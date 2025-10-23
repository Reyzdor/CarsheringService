import MapKit
import SwiftUI

struct Car: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let brand: String
    let fuelLevel: Double
    var isBooked: Bool = false
}

struct MainView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.71209, longitude: 37.51083),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    @State private var selectedCar: Car?
    @State private var showCarDetails = false
    @State private var route: MKRoute?
    
    let fakeUserLocation = CLLocationCoordinate2D(latitude: 55.71209, longitude: 37.51083)
    
    @State private var cars: [Car] = {
        var cars: [Car] = []
        let brands = ["Changan UNI-T", "Chery Arrizo 8", "Haval H3", "Changan UNI-V", "Changan UNI-V"]
        
        for i in 0..<5 {
            let latOffset = Double.random(in: -0.005...0.005)
            let lonOffset = Double.random(in: -0.005...0.005)
            
            let coordinate = CLLocationCoordinate2D(
                latitude: 55.71209 + latOffset,
                longitude: 37.51083 + lonOffset
            )
            
            let fuelLevel = Double.random(in: 0.3...1.0)
            
            cars.append(Car(
                coordinate: coordinate,
                brand: brands[i],
                fuelLevel: fuelLevel
            ))
        }
        
        return cars
    }()
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(cars) { car in
                    Annotation("", coordinate: car.coordinate) {
                        ZStack {
                            Image(systemName: "car.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(car.isBooked ? .red : .blue)
                            
                            if car.isBooked {
                                Circle()
                                    .fill(Color.red.opacity(0.7))
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .onTapGesture {
                            handleCarTap(car)
                        }
                    }
                }
                
                Annotation("", coordinate: fakeUserLocation) {
                    VStack {
                        Image(systemName: "figure.wave")
                            .resizable()
                            .frame(width: 20, height: 35)
                            .foregroundColor(.green)
                        Circle()
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 50, height: 50)
                    }
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            
            if showCarDetails, let car = selectedCar {
                VStack {
                    Spacer()
                    
                    CarDetailView(
                        car: car,
                        distance: route?.distance ?? 0,
                        travelTime: route?.expectedTravelTime ?? 0,
                        onBook: {
                            toggleBookCar(car)
                        },
                        onClose: {
                            showCarDetails = false
                            selectedCar = nil
                            route = nil
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                }
            }
        }
    }
    
    private func handleCarTap(_ car: Car) {
        selectedCar = car
        showCarDetails = true
        
        if route == nil || car.id != selectedCar?.id {
            calculateRoute(to: car.coordinate)
        }
    }
    
    private func calculateRoute(to destination: CLLocationCoordinate2D) {
        let sourceLocation = CLLocation(latitude: fakeUserLocation.latitude, longitude: fakeUserLocation.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        let sourceItem = MKMapItem(location: sourceLocation, address: nil)
        let destinationItem = MKMapItem(location: destinationLocation, address: nil)
        
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
                
                let region = MKCoordinateRegion(
                    center: route.polyline.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
                cameraPosition = .region(region)
            }
        }
    }
    
    private func toggleBookCar(_ car: Car) {
        if let index = cars.firstIndex(where: { $0.id == car.id }) {
            cars[index].isBooked.toggle()
            
            if !cars[index].isBooked {
                showCarDetails = false
                selectedCar = nil
                route = nil
            }
        }
    }
}

struct CarDetailView: View {
    let car: Car
    let distance: Double
    let travelTime: Double
    let onBook: () -> Void
    let onClose: () -> Void
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return "\(Int(distance)) м"
        } else {
            return String(format: "%.1f км", distance / 1000)
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time / 60)
        if minutes < 60 {
            return "\(minutes) мин"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours) ч \(remainingMinutes) мин"
        }
    }
    
    private func fuelLevelColor(_ level: Double) -> Color {
        switch level {
        case 0.7...1.0:
            return .green
        case 0.3..<0.7:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(car.brand)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "fuelpump.fill")
                        .foregroundColor(fuelLevelColor(car.fuelLevel))
                    Text("Топливо: \(Int(car.fuelLevel * 100))%")
                        .foregroundColor(fuelLevelColor(car.fuelLevel))
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "road.lanes")
                        .foregroundColor(.blue)
                    Text("Расстояние: \(formatDistance(distance))")
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("Время пути: \(formatTime(travelTime))")
                    Spacer()
                }
            }
            
            Spacer()
                .frame(height: 10)
            
            Button(action: onBook) {
                Text(car.isBooked ? "Отменить бронирование" : "Забронировать")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(car.isBooked ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 40)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

#Preview {
    MainView()
}
