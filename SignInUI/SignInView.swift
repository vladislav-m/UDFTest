import SwiftUI
import Combine

public struct SignInView: View {
    @ObservedObject
    private var viewModel: SignInViewModel

    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Form {
            TextField("Username", text: $viewModel.state.username)
            TextField("Password", text: $viewModel.state.password)

            Button {
                viewModel.send(.signIn)
            } label : {
                Text("Sign in")
                if viewModel.state.isSigningIn {
                    ProgressView()
                }
            }
        }
    }
}

public struct SignInState {
    public var username: String = ""
    public var password: String = ""
    public var isSigningIn: Bool = false

    public init(
        username: String = "",
        password: String = "",
        isSigningIn: Bool = false
    ) {
        self.username = username
        self.password = password
        self.isSigningIn = isSigningIn
    }
}

public enum SignInAction {
    case signIn
    case signedIn
    case error(AuthService.Error)
}

public final class SignInViewModel: ObservableObject {
    @Published var state: SignInState

    private var cancellables: Set<AnyCancellable> = []

    private let authService: AuthService

    public init(state: SignInState = .init(), authService: AuthService = .shared) {
        self.state = state
        self.authService = authService
    }

    func send(_ action: SignInAction) {
        switch action {
        case .signIn:
            state.isSigningIn = true

            authService.signIn(credentials: .init(
                username: state.username,
                password: state.password
            )).sink { completion in
                if case let .failure(error) = completion {
                    self.send(.error(error))
                }
            } receiveValue: {
                self.send(.signedIn)
            }.store(in: &cancellables)

        case .signedIn:
            state.isSigningIn = false
        }
    }
}

public struct UserCredentials {
    public var username: String
    public var password: String
}

public final class AuthService {
    public static let shared: AuthService = .init()

    public enum Error: Swift.Error {

    }

    public var isAuthorized: AnyPublisher<Bool, Never> {
        return CurrentValueSubject(true)
            .eraseToAnyPublisher()
    }

    public func signIn(credentials: UserCredentials) -> AnyPublisher<Void, Error> {
        return CurrentValueSubject(())
            .delay(for: 2, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: .init())
    }
}
#endif
