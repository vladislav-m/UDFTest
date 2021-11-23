import SwiftUI
import Combine
import ComposableArchitecture

public struct SignInView: View {
    private var store: Store<SignInState, SignInAction>

    public init(
        store: Store<SignInState, SignInAction>
    ) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                TextField("Username", text: viewStore.binding(
                    get: \.username,
                    send: SignInAction.setUsername
                ))
                TextField("Password", text: viewStore.binding(
                    get: \.password,
                    send: SignInAction.setPassword
                ))

                Button {
                    viewStore.send(.signIn)
                } label : {
                    Text("Sign in")
                    if viewStore.isSigningIn {
                        ProgressView()
                    }
                }
            }
        }
    }
}

public struct SignInState: Equatable {
    public var username: String = ""
    public var password: String = ""
    public var isSigningIn: Bool = false
    public var errorMessage: String?

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

public enum SignInAction: Equatable {
    case setUsername(String)
    case setPassword(String)

    case signIn
    case signedIn(Result<Bool, AuthService.Error>)
}

public struct SignInEnvironment {
    private var signIn: (_ credentials: UserCredentials) -> AnyPublisher<Void, AuthService.Error>

    public init(
        signIn: @escaping (_ credentials: UserCredentials) -> AnyPublisher<Void, AuthService.Error>
    ) {
        self.signIn = signIn
    }

    public func signIn(credentials: UserCredentials) -> Effect<SignInAction, Never> {
        return self.signIn(credentials)
            .map { true }
            .catchToEffect(SignInAction.signedIn)
    }
}

extension SignInEnvironment {
    static var live: Self {
        SignInEnvironment(
            signIn: AuthService.shared.signIn
        )
    }

    static var succeeding: Self {
        SignInEnvironment(
            signIn: { _ in CurrentValueSubject(()).eraseToAnyPublisher() }
        )
    }
}

extension Reducer where State == SignInState, Action == SignInAction, Environment == SignInEnvironment {
    static let signIn = Reducer { state, action, env in
        switch action {
        case let .setUsername(username):
            state.username = username
            return .none
        case let .setPassword(password):
            state.password = password
            return .none

        case .signIn:
            state.isSigningIn = true
            state.errorMessage = nil

            let credentials = UserCredentials(
                username: state.username,
                password: state.password
            )

            return env.signIn(credentials: credentials)

        case .signedIn(.success):
            state.isSigningIn = false
            return .none
        case let .signedIn(.failure(error)):
            state.isSigningIn = false
            state.errorMessage = "Попробуйте снова"
            return .none
        }
    }
}

public struct UserCredentials {
    public var username: String
    public var password: String
}

public final class AuthService {
    public static let shared: AuthService = .init()

    public enum Error: Swift.Error, Equatable {

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
        SignInView(store: Store(
            initialState: .init(),
            reducer: .signIn,
            environment: .succeeding
        ))
    }
}
#endif
