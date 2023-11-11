//
//  Fetch_RecipeBrowserTests.swift
//  Fetch-RecipeBrowserTests
//
//  Created by Erich Kumpunen on 11/11/23.
//

import XCTest
@testable import Fetch_RecipeBrowser

final class Fetch_RecipeBrowserTests: XCTestCase {
    /// Just going to include some simple tests here, a project like this doesn't really need much. A single file will suffice.

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }
    
    func testMealFetch() async {
        do {
            let meals: Meals = try await URLService.getData(from: Endpoints.recipes)
            XCTAssert(meals.meals.count > 0, "Failed to find any data.")
            XCTAssert(meals.meals.count == 65, "65 meals present, did not find all 65 meals.")
        } catch {
            XCTFail("Failed with error: \(error), \(error.localizedDescription)")
        }
    }
    
    func testImageFetch() async {
        do {
            let meals: Meals = try await URLService.getData(from: Endpoints.recipes)
            XCTAssert(meals.meals.count > 0, "Failed to find any data.")
            for meal in meals.meals {
                let image = await ImageRequestHandler.shared.getRequest(url: meal.imageRef ?? "")
                XCTAssert(image != nil, "Failed to find image for meal \(meal.name ?? "")")
            }
        } catch {
            XCTFail("Failed with error: \(error), \(error.localizedDescription)")
        }
    }
    
    func testDetailsFetch() async {
        do {
            let meals: Meals = try await URLService.getData(from: Endpoints.recipes)
            XCTAssert(meals.meals.count > 0, "Failed to fetch data.")
            for meal in meals.meals {
                let details: MealDetails = try await URLService.getData(from: Endpoints.details, with: meal.id ?? "")
                XCTAssert(details.meals.first?.idMeal != nil && details.meals.first?.idMeal?.isEmpty == false, "Failed to find details for \(details.meals.first?.strMeal ?? "")")
            }
        } catch {
            XCTFail("Failed with error: \(error), \(error.localizedDescription)")
        }
    }
}
