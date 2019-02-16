//
//  DIContainer.swift
//  DependencyInjector
//
//  Created by Cassius Pacheco on 7/7/18.
//  Copyright © 2018 Cassius Pacheco. All rights reserved.
//

import Foundation

final public class DIContainer {
    public static let shared = DIContainer()
    
    private var factories = [String: Any]()
    private let lock = RecursiveLock()

    public func registerSingleton<T>(_ type: T.Type, factory: @escaping ((DIContainer) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory(self)
        }
    }

    public func contains<T>(_ type: T.Type) -> Bool {
        return lock.sync {
            return factories[String(describing: type)] != nil
        }
    }
}

extension DIContainer {
    // MARK: - Factory methods with no arguments

    public func register<T>(_ type: T.Type, factory: @escaping ((DIContainer) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        return lock.sync {
            let key = String(describing: type)

            if let singleton = self.factories[key] as? T {
                return singleton
            } else if let instanceFactory = self.factories[key] as? ((DIContainer) -> T) {
                return instanceFactory(self)
            } else {
                fatalError("Instance of type `\(type)` hasn't been registered")
            }
        }
    }
}

extension DIContainer {
    // MARK: - Factory methods with one argument

    public func register<T, A>(_ type: T.Type, factory: @escaping ((DIContainer, A) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory
        }
    }

    public func resolve<T, A>(_ type: T.Type, argument: A) -> T {
        return lock.sync {
            if let instanceFactory = self.factories[String(describing: type)] as? ((DIContainer, A) -> T) {
                return instanceFactory(self, argument)
            } else {
                fatalError("Instance of type `\(type)` hasn't been registered")
            }
        }
    }
}

extension DIContainer {
    // MARK: - Factory methods with two arguments

    public func register<T, A, B>(_ type: T.Type, factory: @escaping ((DIContainer, A, B) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory
        }
    }

    public func resolve<T, A, B>(_ type: T.Type, arguments arg1: A, _ arg2: B) -> T {
        return lock.sync {
            if let instanceFactory = self.factories[String(describing: type)] as? ((DIContainer, A, B) -> T) {
                return instanceFactory(self, arg1, arg2)
            } else {
                fatalError("Instance of type `\(type)` hasn't been registered")
            }
        }
    }
}

extension DIContainer {
    // MARK: - Factory methods with three arguments

    public func register<T, A, B, C>(_ type: T.Type, factory: @escaping ((DIContainer, A, B, C) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory
        }
    }

    public func resolve<T, A, B, C>(_ type: T.Type, arguments arg1: A, _ arg2: B, _ arg3: C) -> T {
        return lock.sync {
            if let instanceFactory = self.factories[String(describing: type)] as? ((DIContainer, A, B, C) -> T) {
                return instanceFactory(self, arg1, arg2, arg3)
            } else {
                fatalError("Instance of type `\(type)` hasn't been registered")
            }
        }
    }
}

extension DIContainer {
    // MARK: - Factory methods with four arguments

    public func register<T, A, B, C, D>(_ type: T.Type, factory: @escaping ((DIContainer, A, B, C, D) -> T)) {
        lock.sync {
            self.factories[String(describing: type)] = factory
        }
    }

    public func resolve<T, A, B, C, D>(_ type: T.Type, arguments arg1: A, _ arg2: B, _ arg3: C, _ arg4: D) -> T {
        return lock.sync {
            if let instanceFactory = self.factories[String(describing: type)] as? ((DIContainer, A, B, C, D) -> T) {
                return instanceFactory(self, arg1, arg2, arg3, arg4)
            } else {
                fatalError("Instance of type `\(type)` hasn't been registered")
            }
        }
    }
}
