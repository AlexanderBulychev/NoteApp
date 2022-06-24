//
//  NoteListViewControllerTests.swift
//  NoteApp
//
//  Created by asbul on 23.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import NoteApp
import XCTest

class NoteListViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: NoteListViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupNoteListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupNoteListViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "NoteListViewController") as! NoteListViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class NoteListBusinessLogicSpy: NoteListBusinessLogic {
        var doSomethingCalled = false
        
        func doSomething(request: NoteList.Something.Request) {
            doSomethingCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoSomethingWhenViewIsLoaded() {
        // Given
        let spy = NoteListBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.doSomethingCalled, "viewDidLoad() should ask the interactor to do something")
    }
    
    func testDisplaySomething() {
        // Given
        let viewModel = NoteList.Something.ViewModel()
        
        // When
        loadView()
        sut.displaySomething(viewModel: viewModel)
        
        // Then
        //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
    }
}
