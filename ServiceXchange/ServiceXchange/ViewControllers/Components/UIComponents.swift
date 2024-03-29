// Reusable Public UI Components

import SwiftUI

var controls = HomeViewControls()

func ListingsGrid(listings: [Listing]) -> some View {
    VStack {
        LazyVGrid(columns: controls.gridItems, alignment: .center, spacing: 15) {
            ForEach(listings, id: \.listingId) { listing in
                NavigationLink(destination: ListingDetailView(listing: listing)) {
                    ListingCardView(listing: listing)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                })
            }
        }.padding(.horizontal, 10)
    }
}

func RequestServiceButton(fromUser: User, toUser: User) -> some View {
    VStack {
        NavigationLink(destination: MessageDetailView(messagesVM: MessagesViewModel(fromUser: fromUser, toUser: toUser))) {
            HStack {
                Spacer()
                Text("+  Request Service")
                    .font(.system(size: 16, weight: .bold))
                    .padding(15)
                Spacer()
            }
            .background(CustomColor.sxcgreen)
            .foregroundColor(.black)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(.black, lineWidth: 2)
            )
            .padding(15)
        }
        .simultaneousGesture(TapGesture().onEnded{
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        })
    }
}

//params: image url string and the diameter of the circle
//returns circular profile image (either default or user profile image)
func ProfileImage(imageStr : String, diameter: CGFloat) -> some View {
    return VStack {
        if imageStr.isEmpty {
            Image("blankprofile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: diameter, height: diameter , alignment: .center)
                .clipShape(Circle())
                .overlay(RoundedRectangle(cornerRadius: diameter/2)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
        } else {
            AsyncImage(url: URL(string: imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter , alignment: .center)
                    .clipShape(Circle())
                    .overlay(RoundedRectangle(cornerRadius: diameter/2)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            } placeholder: {
                LoadingView()
                    .frame(width: diameter, height: diameter)
                    .cornerRadius(.infinity)
            }
        }
    }
}

//takes in an image string
//returns a 400 x 250 image (either a default or a user image)
func ProfileBackground(imageStr : String) -> some View {
    return VStack {
        if imageStr == "" {
            Image("sunsetTest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.20, alignment: .top)
                .clipShape(Rectangle())
                .cornerRadius(17)
                .overlay(RoundedRectangle(cornerRadius: 17)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
        } else {
            AsyncImage(url: URL(string: imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.20, alignment: .top)
                    .clipShape(Rectangle())
                    .cornerRadius(17)
                    .overlay(RoundedRectangle(cornerRadius: 17)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            } placeholder: {
                LoadingView()
                    .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.2)
                    .cornerRadius(17)
            }
        }
    }
}//showDetailImage


func ListingCardView(listing: Listing) -> some View {
    let image_url = listing.imageUrls.first ?? ""
    return ZStack(alignment: .bottom) {
        UrlImage(url: image_url)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: controls.width, height: controls.height)
            .clipped()
        
        cardGradient()
            .rotationEffect(.degrees(180))
            .frame(width: controls.width, height: controls.height)
         
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(listing.title )
                    .foregroundColor(.white)
                    .lineLimit(1)
            }.padding(10)
            Spacer()
        }
    }
    .frame(width: controls.width, height: controls.height)
    .overlay(
        RoundedRectangle(cornerRadius: 17)
            .stroke(.black, lineWidth: 1)
    )
    .padding(1)
    .cornerRadius(17)
}

func underlinedTextField(title: String, text: Binding <String>, width: CGFloat, height: CGFloat, color: Color) -> some View {
    return TextField(title, text: text)
                .frame(width: width, height: height)
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(color))
                .padding(10)
}

func passwordTextField(title: String, text: Binding <String>, width: CGFloat, height: CGFloat, color: Color, showPassword: Binding<Bool>) -> some View {
    return Group {
        if showPassword.wrappedValue {
            TextField(title, text: text)
                .frame(width: width, height: height)
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(color))
                .textContentType(.password)
        } else {
            SecureField(title, text: text)
                .frame(width: width, height: height)
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(color))
                .textContentType(.password)
        }
    }
}

func cardGradient() -> LinearGradient {
    LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color.gray.opacity(0.015), location: 0.0),
            .init(color: Color.black.opacity(0.025), location: 0.025),
            .init(color: Color.black.opacity(0.04), location: 0.05),
            .init(color: Color.black.opacity(0.07), location: 0.1),
            .init(color: Color.black.opacity(0.1), location: 0.15),
            .init(color: Color.black.opacity(0.15), location: 0.2),
            .init(color: Color.black.opacity(0.2), location: 0.25),
            .init(color: Color.black.opacity(0.25), location: 0.3),
            .init(color: Color.black.opacity(0.3), location: 0.35),
            .init(color: Color.black.opacity(0.35), location: 0.4),
            .init(color: Color.black.opacity(0.4), location: 0.45),
            .init(color: Color.black.opacity(0.45), location: 0.5),
            .init(color: Color.black.opacity(0.525), location: 0.55),
            .init(color: Color.black.opacity(0.6), location: 0.6),
            .init(color: Color.black.opacity(0.65), location: 0.65),
            .init(color: Color.black.opacity(0.7), location: 0.7),
            .init(color: Color.black.opacity(0.75), location: 0.75),
            .init(color: Color.black.opacity(0.8), location: 0.8),
            .init(color: Color.black.opacity(0.825), location: 0.85),
            .init(color: Color.black.opacity(0.85), location: 0.9),
            .init(color: Color.black.opacity(0.875), location: 0.95)
        ]),
        startPoint: UnitPoint(x: 0.5, y: 0.5),
        endPoint: UnitPoint(x: 0.5, y: 0.0))
        //.rotationEffect(.degrees(180))
}

enum SwipeHVDirection: String {
    case left, right, up, down, none
}
func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
    if value.startLocation.x < value.location.x - 24 {
            return .left
          }
          if value.startLocation.x > value.location.x + 24 {
            return .right
          }
          if value.startLocation.y < value.location.y - 24 {
            return .down
          }
          if value.startLocation.y > value.location.y + 24 {
            return .up
          }
    return .none
}

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
