=package org.springframework.samples.petclinic.rest.steps;

import static org.junit.jupiter.api.Assertions.*;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import io.restassured.response.Response;
import org.springframework.samples.petclinic.rest.api.ApiClient;

import java.util.Map;

public class OwnerSteps {

    private final ApiClient apiClient = new ApiClient();
    private Response response;
    private Map<String, String> ownerData;

    @Given("the PetClinic REST API is available")
    public void petclinic_api_is_available() {
        apiClient.setBaseUri("http://localhost:9966/petclinic/api");
    }

    @When("I request all owners")
    public void i_request_all_owners() {
        response = apiClient.getAllOwners();
    }

    @Then("the response status code should be {int}")
    public void the_response_status_code_should_be(Integer statusCode) {
        assertEquals(statusCode.intValue(), response.getStatusCode());
    }

    @Then("the response should contain a list of owners")
    public void the_response_should_contain_a_list_of_owners() {
        assertTrue(response.jsonPath().getList("$").size() >= 0);
    }

    @Given("an owner with ID {int} exists")
    public void an_owner_with_id_exists(Integer ownerId) {
        response = apiClient.getOwnerById(ownerId);
        assertEquals(200, response.getStatusCode(), "Owner with ID " + ownerId + " does not exist");
    }

    @When("I request the owner with ID {int}")
    public void i_request_the_owner_with_id(Integer ownerId) {
        response = apiClient.getOwnerById(ownerId);
    }

    @When("I request the owner with ID {string}")
    public void i_request_the_owner_with_id_string(String ownerId) {
        response = apiClient.getOwnerByIdRaw(ownerId);
    }

    @Then("the response should contain owner details with ID {int}")
    public void the_response_should_contain_owner_details_with_id(Integer ownerId) {
        Integer id = response.jsonPath().getInt("id");
        assertEquals(ownerId, id);
    }

    @Given("I have owner data to create")
    public void i_have_owner_data_to_create(DataTable dataTable) {
        ownerData = dataTable.asMap(String.class, String.class);
    }

    @When("I create a new owner with the provided data")
    public void i_create_a_new_owner_with_the_provided_data() {
        response = apiClient.createOwner(ownerData);
    }

    @Then("the response should contain the created owner with firstName {string} and lastName {string}")
    public void the_response_should_contain_the_created_owner_with_firstName_and_lastName(String firstName, String lastName) {
        assertEquals(firstName, response.jsonPath().getString("firstName"));
        assertEquals(lastName, response.jsonPath().getString("lastName"));
    }

    @Given("I have updated owner data")
    public void i_have_updated_owner_data(DataTable dataTable) {
        ownerData = dataTable.asMap(String.class, String.class);
    }

    @When("I update the owner with ID {int} using the provided data")
    public void i_update_the_owner_with_id_using_the_provided_data(Integer ownerId) {
        response = apiClient.updateOwner(ownerId, ownerData);
    }

    @When("I update the owner with ID {string} using the provided data")
    public void i_update_the_owner_with_id_string_using_the_provided_data(String ownerId) {
        response = apiClient.updateOwnerRaw(ownerId, ownerData);
    }

    @When("I delete the owner with ID {int}")
    public void i_delete_the_owner_with_id(Integer ownerId) {
        response = apiClient.deleteOwner(ownerId);
    }

    @When("I delete the owner with ID {string}")
    public void i_delete_the_owner_with_id_string(String ownerId) {
        response = apiClient.deleteOwnerRaw(ownerId);
    }
}
```

```TEST_RUNNER
package org.springframework.samples.petclinic.rest.runner;

import io.cucumber.junit.platform.engine.Cucumber;

@Cucumber
public class CucumberTestRunner {
}
```