//
//  DIContainerTests.swift
//  DependencyInjectionTests
//
//  Created by Cassius Pacheco on 7/7/18.
//  Copyright © 2018 Cassius Pacheco. All rights reserved.
//

import XCTest
@testable import DependencyInjection

final class DIContainerTests: XCTestCase {
    private struct DummyTest: Equatable {
        let name: String
        let id: String = UUID().uuidString
    }

    private struct MultipleArgsDummyTest: Equatable {
        let name: String
        let city: String
        let state: String
        let country: String
    }

    func testContainerResolvesRegisteredClasses() {
        let container = DIContainer()
        
        container.register(DummyTest.self) { (di) -> DummyTest in
            return DummyTest(name: "Test")
        }
        
        let resolvedTest1 = container.resolve(DummyTest.self)
        let resolvedTest2 = container.resolve(DummyTest.self)
        
        XCTAssertNotEqual(resolvedTest1, resolvedTest2, "Factory creates a new instance for every instance resolved")
    }
    
    func testContainerResolvesSingletonRegisteredClasses() {
        let container = DIContainer()
        
        container.registerSingleton(DummyTest.self) { (di) -> DummyTest in
            return DummyTest(name: "Test")
        }
        
        let resolvedTest1 = container.resolve(DummyTest.self)
        let resolvedTest2 = container.resolve(DummyTest.self)
        
        XCTAssertEqual(resolvedTest1, resolvedTest2, "Singleton factories retunrs the same instance for every instance resolved")
    }
    
    func testContainerContainsRegisteredSingletonClass() {
        let container = DIContainer()
        
        XCTAssertFalse(container.contains(DummyTest.self))
        
        container.registerSingleton(DummyTest.self) { di -> DummyTest in
            return DummyTest(name: "Test")
        }
        
        XCTAssertTrue(container.contains(DummyTest.self), "container should contain the registered singleton")
    }
    
    func testContainerContainsRegisteredFactoryClass() {
        let container = DIContainer()
        
        XCTAssertFalse(container.contains(DummyTest.self))
        
        container.register(DummyTest.self) { di -> DummyTest in
            return DummyTest(name: "Test")
        }
        
        XCTAssertTrue(container.contains(DummyTest.self), "container should contain the registered factory")
    }
}

extension DIContainerTests {
    // MARK: - Test One Argument

    func testContainerContainsRegisteredFactoryClassWithSingleArgument() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(DummyTest.self))

        container.register(DummyTest.self) { di, name -> DummyTest in
            return DummyTest(name: name)
        }

        XCTAssertTrue(container.contains(DummyTest.self), "container should contain the registered factory")
    }

    func testContainerResolveFactoryClassWithSingleArgument() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(DummyTest.self))

        container.register(DummyTest.self) { di, name -> DummyTest in
            return DummyTest(name: name)
        }

        let resolved = container.resolve(DummyTest.self, argument: "Some name")
        XCTAssertEqual(resolved.name, "Some name")
    }
}

extension DIContainerTests {
    // MARK: - Test Two Argument

    func testContainerContainsRegisteredFactoryClassWithTwoArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(MultipleArgsDummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: "NSW", country: "Australia")
        }

        XCTAssertTrue(container.contains(MultipleArgsDummyTest.self), "container should contain the registered factory")
    }

    func testContainerResolveFactoryClassWithTwoArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(DummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: "NSW", country: "Australia")
        }

        let resolved = container.resolve(MultipleArgsDummyTest.self, arguments: "Some name", "Sydney")
        XCTAssertEqual(resolved.name, "Some name")
        XCTAssertEqual(resolved.city, "Sydney")
        XCTAssertEqual(resolved.state, "NSW")
        XCTAssertEqual(resolved.country, "Australia")
    }
}

extension DIContainerTests {
    // MARK: - Test Three Argument

    func testContainerContainsRegisteredFactoryClassWithThreeArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(MultipleArgsDummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city, state -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: state, country: "Australia")
        }

        XCTAssertTrue(container.contains(MultipleArgsDummyTest.self), "container should contain the registered factory")
    }

    func testContainerResolveFactoryClassWithThreeArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(DummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city, state -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: state, country: "Australia")
        }

        let resolved = container.resolve(MultipleArgsDummyTest.self, arguments: "Some name", "Sydney", "NSW")
        XCTAssertEqual(resolved.name, "Some name")
        XCTAssertEqual(resolved.city, "Sydney")
        XCTAssertEqual(resolved.state, "NSW")
        XCTAssertEqual(resolved.country, "Australia")
    }
}

extension DIContainerTests {
    // MARK: - Test Three Argument

    func testContainerContainsRegisteredFactoryClassWithFourArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(MultipleArgsDummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city, state, country -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: state, country: country)
        }

        XCTAssertTrue(container.contains(MultipleArgsDummyTest.self), "container should contain the registered factory")
    }

    func testContainerResolveFactoryClassWithFourArguments() {
        let container = DIContainer()

        XCTAssertFalse(container.contains(DummyTest.self))

        container.register(MultipleArgsDummyTest.self) { di, name, city, state, country -> MultipleArgsDummyTest in
            return MultipleArgsDummyTest(name: name, city: city, state: state, country: country)
        }

        let resolved = container.resolve(MultipleArgsDummyTest.self, arguments: "Some name", "Sydney", "NSW", "Australia")
        XCTAssertEqual(resolved.name, "Some name")
        XCTAssertEqual(resolved.city, "Sydney")
        XCTAssertEqual(resolved.state, "NSW")
        XCTAssertEqual(resolved.country, "Australia")
    }
}
