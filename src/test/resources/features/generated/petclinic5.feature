=Feature: PetClinic REST API - Owners Management

  Background:
    Given the PetClinic REST API is available

  Scenario: Retrieve all owners
    When I request all owners
    Then the response status code should be 200
    And the response should contain a list of owners

  Scenario: Retrieve an owner by ID
    Given an owner with ID 1 exists
    When I request the owner with ID 1
    Then the response status code should be 200
    And the response should contain owner details with ID 1

  Scenario: Create a new owner
    Given I have owner data to create
      | firstName | lastName | address        | city       | telephone  |
      | John      | Doe      | 123 Elm Street | Springfield| 1234567890 |
    When I create a new owner with the provided data
    Then the response status code should be 201
    And the response should contain the created owner with firstName "John" and lastName "Doe"

  Scenario: Update an existing owner
    Given an owner with ID 1 exists
    And I have updated owner data
      | firstName | lastName | address        | city       | telephone  |
      | Jane      | Smith    | 456 Oak Avenue | Shelbyville| 0987654321 |
    When I update the owner with ID 1 using the provided data
    Then the response status code should be 204

  Scenario: Delete an owner by ID
    Given an owner with ID 1 exists
    When I delete the owner with ID 1
    Then the response status code should be 204
```