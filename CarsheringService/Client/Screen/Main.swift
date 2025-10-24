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
            let coordinate = CLLocationCoordinate2D(latitude: 55.71209 + latOffset, longitude: 37.51083 + lonOffset)
            let fuelLevel = Double.random(in: 0.3...1.0)
            cars.append(Car(coordinate: coordinate, brand: brands[i], fuelLevel: fuelLevel))
        }
        return cars
    }()
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(cars) { car in
                    Annotation("", coordinate: car.coordinate) {
                        Image(systemName: "car.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(car.isBooked ? .red : .blue)
                            .onTapGesture { handleCarTap(car) }
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
                    MapPolyline(route.polyline).stroke(.blue, lineWidth: 5)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            if showCarDetails, let car = selectedCar {
                VStack(spacing: 0) {
                    Spacer()
                    CarDetailView(
                        car: car,
                        distance: route?.distance ?? 0,
                        travelTime: route?.expectedTravelTime ?? 0,
                        onBook: { toggleBookCar(car) },
                        onClose: {
                            showCarDetails = false
                            selectedCar = nil
                            route = nil
                        }
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.33)
                    .transition(.move(edge: .bottom))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showCarDetails)
    }
    
    private func handleCarTap(_ car: Car) {
        selectedCar = car
        showCarDetails = true
        calculateRoute(to: car.coordinate)
    }
    
    private func calculateRoute(to destination: CLLocationCoordinate2D) {
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: fakeUserLocation))
        let destItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destItem
        request.transportType = .walking
        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                self.route = route
                let region = MKCoordinateRegion(center: route.polyline.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                cameraPosition = .region(region)
            }
        }
    }
    
    private func toggleBookCar(_ car: Car) {
        if let index = cars.firstIndex(where: { $0.id == car.id }) {
            let wasBooked = cars[index].isBooked
            cars[index].isBooked.toggle()
            if wasBooked {
                route = nil
                showCarDetails = false
                selectedCar = nil
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
    @State private var isBookedState: Bool = false
    
    private func formatDistance(_ distance: Double) -> String {
        distance < 1000 ? "\(Int(distance)) м" : String(format: "%.1f км", distance / 1000)
    }
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time / 60)
        return minutes < 60 ? "\(minutes) мин" : "\(minutes / 60) ч \(minutes % 60) мин"
    }
    private func fuelColor(_ level: Double) -> Color {
        switch level {
        case 0.7...1.0: return .green
        case 0.3..<0.7: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(car.brand)
                    .font(.title3.bold())
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Топливо: \(Int(car.fuelLevel * 100))%", systemImage: "fuelpump.fill")
                    .foregroundColor(fuelColor(car.fuelLevel))
                Label("Расстояние: \(formatDistance(distance))", systemImage: "road.lanes")
                    .foregroundColor(.blue)
                Label("Время пути: \(formatTime(travelTime))", systemImage: "clock")
                    .foregroundColor(.blue)
            }
            .font(.body)
            .padding(.top, 6)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isBookedState.toggle()
                }
                onBook()
            }) {
                Text(isBookedState ? "Отменить бронирование" : "Забронировать")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(isBookedState ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            }
            .padding(.top, 10)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.15), radius: 10, y: -4)
        )
    }
}

private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct RootView: View {
    var body: some View {
        MainView().ignoresSafeArea()
    }
}

#Preview {
    RootView()
}
