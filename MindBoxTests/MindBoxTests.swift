//
//  MindBoxTests.swift
//  MindBoxTests
//
//  Created by Mikhail Barilov on 12.01.2021.
//  Copyright © 2021 Mikhail Barilov. All rights reserved.
//

import XCTest
@testable import MindBox

class MindBoxTests: XCTestCase, MindBoxDelegate {

    var mindBoxDidInstalledFlag: Bool = false
    var apnsTokenDidUpdatedFlag: Bool = false

    override func setUp() {
        DIManager.shared.dropContainer()
        DIManager.shared.registerServices()

        DIManager.shared.container.registerInContainer { _ -> IPersistenceStorage in
            return MockPersistenceStorage()
        }

        DIManager.shared.container.registerInContainer { _ -> APIService in
            return MockApiService()
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOnInitCase1() {

        var coreController = CoreController()
        

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        MindBox.shared.delegate = self

        let configuration1 = try! MBConfiguration(plistName: "TestConfig1")
        coreController.initialization(configuration: configuration1)

        do {
            let exists = NSPredicate(format: "mindBoxDidInstalledFlag == true && apnsTokenDidUpdatedFlag == false")
            expectation(for: exists, evaluatedWith: self, handler: nil)
            waitForExpectations(timeout: 10, handler: nil)

            mindBoxDidInstalledFlag = false
            apnsTokenDidUpdatedFlag = false

        }
        let deviceUUID =  try! MindBox.shared.deviceUUID()

    	//        //        //        //        //        //		//        //        //        //        //        //

        let configuration2 = try! MBConfiguration(plistName: "TestConfig2")
        coreController.initialization(configuration: configuration2)

        do {
            let exists = NSPredicate(format: "mindBoxDidInstalledFlag == false && apnsTokenDidUpdatedFlag == true")
            expectation(for: exists, evaluatedWith: self, handler: nil)
            waitForExpectations(timeout: 10, handler: nil)

            let deviceUUID2 = try! MindBox.shared.deviceUUID()
            XCTAssert(deviceUUID == deviceUUID2)

            mindBoxDidInstalledFlag = false
            apnsTokenDidUpdatedFlag = false
        }

        let persistensStorage: IPersistenceStorage = diManager.container.resolveOrDie()

        persistensStorage.reset()
        coreController = CoreController()

        //        //        //        //        //        //        //        //        //        //        //        //

        let configuration3 = try! MBConfiguration(plistName: "TestConfig3")

        coreController.initialization(configuration: configuration3)

        do {
            let exists = NSPredicate(format: "mindBoxDidInstalledFlag == true && apnsTokenDidUpdatedFlag == false")
            expectation(for: exists, evaluatedWith: self, handler: nil)
            waitForExpectations(timeout: 10, handler: nil)

            mindBoxDidInstalledFlag = false
            apnsTokenDidUpdatedFlag = false
        }

    }

    // MARK: - MindBoxDelegate

    func mindBoxDidInstalled() {
        mindBoxDidInstalledFlag = true
    }

    func mindBoxInstalledFailed(error: MindBox.Errors) {

    }

    func apnsTokenDidUpdated() {
        apnsTokenDidUpdatedFlag = true
    }
}
