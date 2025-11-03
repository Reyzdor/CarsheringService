import SwiftUI
import MapKit
import CoreData

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct Car: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let brand: String
    let fuelLevel: Double
}

struct CarBooking {
    let carID: UUID
    var isBooked: Bool
    var startTime: Date?
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
    let fakeUserLocation = CLLocationCoordinate2D(latitude: 55.71209, longitude: 37.51083)

    @State private var bookings: [UUID: CarBooking] = [:]
    private let pricePerMinute: Double = 12
    @State private var timer: Timer? = nil
    @State private var now: Date = Date()
    @State private var distanceToCar: Double = 0
    @State private var timeToCar: TimeInterval = 0

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(cars) { car in
                    Annotation("", coordinate: car.coordinate) {
                        Image(systemName: "car.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(bookings[car.id]?.isBooked ?? false ? .red : .blue)
                            .shadow(radius: 3)
                            .onTapGesture { handleCarTap(car) }
                    }
                }

                Annotation("", coordinate: fakeUserLocation) {
                    VStack(spacing: 3) {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .frame(width: 20, height: 35)
                            .foregroundColor(.green)
                        Circle()
                            .fill(Color.green.opacity(0.25))
                            .frame(width: 45, height: 45)
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
                VStack {
                    Spacer()
                    CarDetailView(
                        car: car,
                        booking: bookings[car.id],
                        distance: distanceToCar,
                        travelTime: timeToCar,
                        pricePerMinute: pricePerMinute,
                        now: $now,
                        onBook: { toggleBookCar(car) },
                        onClose: { closeCarDetails() }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.35)
                    .padding(.top, 5)
                }
            }
        }
        .onAppear { startGlobalTimer() }
        .onDisappear { timer?.invalidate() }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showCarDetails)
    }

    private func handleCarTap(_ car: Car) {
        selectedCar = car
        showCarDetails = true
        calculateRoute(to: car.coordinate)
        calculateDistanceAndTime(to: car.coordinate)
    }

    private func calculateRoute(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: fakeUserLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                self.route = route
                let region = MKCoordinateRegion(center: route.polyline.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                cameraPosition = .region(region)
            }
        }
    }

    private func calculateDistanceAndTime(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: fakeUserLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                self.distanceToCar = route.distance
                self.timeToCar = route.expectedTravelTime
            }
        }
    }

    private func toggleBookCar(_ car: Car) {
        if bookings.values.contains(where: { $0.isBooked && $0.carID != car.id }) { return }
        var booking = bookings[car.id] ?? CarBooking(carID: car.id, isBooked: false, startTime: nil)
        if booking.isBooked {
            booking.isBooked = false
            booking.startTime = nil
        } else {
            booking.isBooked = true
            booking.startTime = Date()
        }
        bookings[car.id] = booking
    }

    private func closeCarDetails() {
        showCarDetails = false
        selectedCar = nil
        route = nil
        distanceToCar = 0
        timeToCar = 0
    }

    private func startGlobalTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            now = Date()
        }
    }
}

struct CarDetailView: View {
    let car: Car
    let booking: CarBooking?
    let distance: Double
    let travelTime: TimeInterval
    let pricePerMinute: Double
    @Binding var now: Date
    let onBook: () -> Void
    let onClose: () -> Void

    var body: some View {
        let booked = booking?.isBooked ?? false
        let start = booking?.startTime ?? now
        let elapsed = booked ? now.timeIntervalSince(start) : 0
        let minutesElapsed = Int(elapsed / 60)
        let cost = minutesElapsed * Int(pricePerMinute)

        VStack(spacing: 12) {
            Capsule()
                .fill(Color.white.opacity(0.4))
                .frame(width: 50, height: 5)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(car.brand)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(6)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                }

                HStack(spacing: 20) {
                    Label("\(Int(car.fuelLevel * 100))%", systemImage: "fuelpump.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    Label("\(formatDistance(distance))", systemImage: "road.lanes")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                    Label("\(formatTime(travelTime))", systemImage: "clock")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                }

                if booked {
                    Text("Время аренды: \(formatTime(elapsed))")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.yellow)
                    Text("Стоимость аренды: \(cost) ₽")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)

            Button(action: onBook) {
                Text(booked ? "Отменить броннирование" : "Забронировать")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(booked ? Color.orange.opacity(0.9) : Color.white)
                    .foregroundColor(booked ? .white : Color.purple)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.25), radius: 8, y: 3)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.35)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.9, green: 0.05, blue: 1.0),
                    Color(red: 0.75, green: 0.05, blue: 0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedCorner(radius: 26, corners: [.topLeft, .topRight]))
        )
        .shadow(color: .black.opacity(0.3), radius: 10, y: -4)
        .ignoresSafeArea(edges: [.bottom])
    }

    private func formatDistance(_ distance: Double) -> String {
        distance < 1000 ? "\(Int(distance)) м" : String(format: "%.1f км", distance / 1000)
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let sec = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, sec)
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath)
    }
}
