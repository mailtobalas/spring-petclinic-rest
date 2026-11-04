=Feature: Owner Management via PetClinic REST API

  Background:
    Given the PetClinic REST API is available

  # GET /owners
  Scenario: Retrieve all owners successfully
    When I request all owners
    Then the response status code should be 200
    And the response should contain a list of owners

  # GET /owners/{ownerId} - positive and negative
  Scenario Outline: Retrieve owner by ID
    Given an owner with ID <ownerId> exists
    When I request the owner with ID <ownerId>
    Then the response status code should be 200
    And the response should contain owner details with ID <ownerId>

    Examples:
      | ownerId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve owner by non-existent ID
    When I request the owner with ID <ownerId>
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 999999  |
      | -1      |

  Scenario Outline: Retrieve owner by invalid ID format
    When I request the owner with ID <ownerId>
    Then the response status code should be 400

    Examples:
      | ownerId   |
      | abc       |
      | 1.5       |
      |           |

  # POST /owners - create owner positive and negative
  Scenario: Create a new owner with valid data
    Given I have owner data to create
      | firstName | John    |
      | lastName  | Doe     |
      | address   | 123 St  |
      | city      | Metropolis |
      | telephone | 1234567890 |
    When I create a new owner with the provided data
    Then the response status code should be 201
    And the response should contain the created owner with firstName "John" and lastName "Doe"

  Scenario Outline: Create a new owner with missing required fields
    Given I have owner data to create
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | 123 St      |
      | city      | Metropolis  |
      | telephone | 1234567890  |
    When I create a new owner with the provided data
    Then the response status code should be 400

    Examples:
      | firstName | lastName |
      |           | Doe      |
      | John      |          |
      |           |          |

  Scenario Outline: Create a new owner with invalid telephone number
    Given I have owner data to create
      | firstName | Jane       |
      | lastName  | Smith      |
      | address   | 456 Ave    |
      | city      | Gotham     |
      | telephone | <telephone>|
    When I create a new owner with the provided data
    Then the response status code should be 400

    Examples:
      | telephone  |
      | abcdef     |
      | 123-456-78 |
      |            |

  # PUT /owners/{ownerId} - update owner positive and negative
  Scenario Outline: Update an existing owner with valid data
    Given an owner with ID <ownerId> exists
    And I have updated owner data
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I update the owner with ID <ownerId> using the provided data
    Then the response status code should be 200
    And the response should contain the created owner with firstName "<firstName>" and lastName "<lastName>"

    Examples:
      | ownerId | firstName | lastName | address    | city      | telephone  |
      | 1       | Alice     | Wonderland | 789 Blvd  | Wonderland | 9876543210 |
      | 2       | Bob       | Builder   | 321 Road   | Builderland| 5555555555 |

  Scenario Outline: Update a non-existent owner
    Given I have updated owner data
      | firstName | Ghost    |
      | lastName  | User     |
      | address   | Nowhere  |
      | city      | NullCity |
      | telephone | 0000000000 |
    When I update the owner with ID <ownerId> using the provided data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 999999  |
      | -1      |

  Scenario Outline: Update an owner with invalid data
    Given an owner with ID <ownerId> exists
    And I have updated owner data
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | 123 St      |
      | city      | Cityville   |
      | telephone | <telephone> |
    When I update the owner with ID <ownerId> using the provided data
    Then the response status code should be 400

    Examples:
      | ownerId | firstName | lastName | telephone  |
      | 1       |           | Smith    | 1234567890 |
      | 1       | John      |          | 1234567890 |
      | 1       | John      | Smith    | abcdef     |
      | 1       | John      | Smith    |            |

  # DELETE /owners/{ownerId} - delete owner positive and negative
  Scenario Outline: Delete an existing owner
    Given an owner with ID <ownerId> exists
    When I delete the owner with ID <ownerId>
    Then the response status code should be 204

  Scenario Outline: Delete a non-existent owner
    When I delete the owner with ID <ownerId>
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 999999  |
      | -1      |

  Scenario Outline: Delete owner with invalid ID format
    When I delete the owner with ID <ownerId>
    Then the response status code should be 400

    Examples:
      | ownerId |
      | abc     |
      | 1.5     |
      |         |
```