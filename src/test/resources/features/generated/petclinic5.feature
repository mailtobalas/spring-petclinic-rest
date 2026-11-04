=Feature: Spring Petclinic REST API

  Background:
    Given the API base URL is configured

  # Owners API
  Scenario Outline: Retrieve owner by ID successfully
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 200
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  |
      | 1       | Davis     |
      | 2       | Coleman   |

  Scenario Outline: Retrieve owner by ID - owner not found
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new owner successfully
    Given the following owner data:
      | firstName | lastName | address          | city       | telephone   |
      | <firstName> | <lastName> | <address>       | <city>     | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 201
    And the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | firstName | lastName | address          | city       | telephone   |
      | John      | Smith    | 123 Elm St       | Springfield| 1234567890  |
      | Alice     | Johnson  | 456 Oak Ave      | Shelbyville| 0987654321  |

  Scenario Outline: Create a new owner with missing required fields
    Given the following owner data:
      | firstName | lastName | address | city | telephone |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      | firstName | lastName | address | city | telephone |
      |           | Smith    | 123 Elm St | Springfield | 1234567890 |
      | John      |          | 123 Elm St | Springfield | 1234567890 |
      | John      | Smith    |           | Springfield | 1234567890 |
      | John      | Smith    | 123 Elm St |            | 1234567890 |
      | John      | Smith    | 123 Elm St | Springfield |            |

  Scenario Outline: Update an existing owner successfully
    Given the following owner data:
      | firstName | lastName | address          | city       | telephone   |
      | <firstName> | <lastName> | <address>       | <city>     | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 204

    Examples:
      | ownerId | firstName | lastName | address          | city       | telephone   |
      | 1       | John      | Smith    | 789 Pine Rd      | Springfield| 1112223333  |
      | 2       | Alice     | Johnson  | 321 Maple St     | Shelbyville| 4445556666  |

  Scenario Outline: Update an owner that does not exist
    Given the following owner data:
      | firstName | lastName | address          | city       | telephone   |
      | John      | Smith    | 789 Pine Rd      | Springfield| 1112223333  |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  Scenario Outline: Delete an existing owner successfully
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 204

    Examples:
      | ownerId |
      | 1       |
      | 2       |

  Scenario Outline: Delete an owner that does not exist
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  # Pets API
  Scenario Outline: Retrieve pet by ID successfully
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 200
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    |
      | 1     | Leo     |
      | 2     | Basil   |

  Scenario Outline: Retrieve pet by ID - pet not found
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |
      | 0     |

  Scenario Outline: Create a new pet successfully
    Given the following pet data:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId>|
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | name   | birthDate  | typeId | ownerId |
      | Rocky  | 2018-01-01 | 1      | 1       |
      | Bella  | 2019-05-20 | 2      | 2       |

  Scenario Outline: Create a new pet with missing or invalid fields
    Given the following pet data:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId>|
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      | name | birthDate  | typeId | ownerId |
      |      | 2018-01-01 | 1      | 1       |
      | Rocky|            | 1      | 1       |
      | Rocky| 2018-01-01 |        | 1       |
      | Rocky| 2018-01-01 | 1      |         |

  Scenario Outline: Update an existing pet successfully
    Given the following pet data:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId>|
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 204

    Examples:
      | petId | name   | birthDate  | typeId | ownerId |
      | 1     | Max    | 2017-03-15 | 1      | 1       |
      | 2     | Daisy  | 2016-07-10 | 2      | 2       |

  Scenario Outline: Update a pet that does not exist
    Given the following pet data:
      | name   | birthDate  | typeId | ownerId |
      | Max    | 2017-03-15 | 1      | 1       |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |
      | 0     |

  Scenario Outline: Delete an existing pet successfully
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 204

    Examples:
      | petId |
      | 1     |
      | 2     |

  Scenario Outline: Delete a pet that does not exist
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |
      | 0     |

  # Visits API
  Scenario Outline: Retrieve visit by ID successfully
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 200
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description          |
      | 1       | Annual checkup       |
      | 2       | Vaccination          |

  Scenario Outline: Retrieve visit by ID - visit not found
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new visit successfully
    Given the following visit data:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | petId | visitDate  | description          |
      | 1     | 2023-01-01 | Annual checkup       |
      | 2     | 2023-06-15 | Vaccination          |

  Scenario Outline: Create a new visit with missing or invalid fields
    Given the following visit data:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      | petId | visitDate  | description          |
      |       | 2023-01-01 | Annual checkup       |
      | 1     |            | Annual checkup       |
      | 1     | 2023-01-01 |                      |

  Scenario Outline: Update an existing visit successfully
    Given the following visit data:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 204

    Examples:
      | visitId | petId | visitDate  | description          |
      | 1       | 1     | 2023-02-01 | Annual checkup       |
      | 2       | 2     | 2023-07-01 | Vaccination          |

  Scenario Outline: Update a visit that does not exist
    Given the following visit data:
      | petId | visitDate  | description          |
      | 1     | 2023-02-01 | Annual checkup       |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |
      | 0       |

  Scenario Outline: Delete an existing visit successfully
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 204

    Examples:
      | visitId |
      | 1       |
      | 2       |

  Scenario Outline: Delete a visit that does not exist
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |
      | 0       |