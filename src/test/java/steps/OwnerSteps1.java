=package org.springframework.samples.petclinic.rest.steps;

import io.cucumber.java.en.*;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.jupiter.api.Assertions;
import org.springframework.samples.petclinic.rest.api.PetclinicApiClient;

import java.util.List;
import java.util.Map;

public class PetclinicStepDefinitions {

    private final PetclinicApiClient apiClient = new PetclinicApiClient();
    private Response response;

    @Given("the API base URL is configured")
    public void the_api_base_url_is_configured() {
        apiClient.configureBaseUrl();
    }

    @When("I send a GET request to {string}")
    public void i_send_a_get_request_to(String endpoint) {
        response = apiClient.get(endpoint);
    }

    @When("I send a POST request to {string} with body:")
    public void i_send_a_post_request_to_with_body(String endpoint, String body) {
        response = apiClient.post(endpoint, body);
    }

    @When("I send a PUT request to {string} with body:")
    public void i_send_a_put_request_to_with_body(String endpoint, String body) {
        response = apiClient.put(endpoint, body);
    }

    @When("I send a PATCH request to {string} with body:")
    public void i_send_a_patch_request_to_with_body(String endpoint, String body) {
        response = apiClient.patch(endpoint, body);
    }

    @When("I send a DELETE request to {string}")
    public void i_send_a_delete_request_to(String endpoint) {
        response = apiClient.delete(endpoint);
    }

    @Then("the response status code should be {int}")
    public void the_response_status_code_should_be(Integer expectedStatusCode) {
        Assertions.assertEquals(expectedStatusCode.intValue(), response.statusCode(),
                "Expected HTTP status code does not match actual");
    }

    @Then("the response JSON should contain owner with id {int}")
    public void the_response_json_should_contain_owner_with_id(Integer ownerId) {
        Assertions.assertEquals(ownerId.intValue(), response.jsonPath().getInt("id"),
                "Owner id in response does not match");
    }

    @Then("the response JSON should contain owner with firstName {string} and lastName {string}")
    public void the_response_json_should_contain_owner_with_firstName_and_lastName(String firstName, String lastName) {
        Assertions.assertEquals(firstName, response.jsonPath().getString("firstName"),
                "Owner firstName in response does not match");
        Assertions.assertEquals(lastName, response.jsonPath().getString("lastName"),
                "Owner lastName in response does not match");
    }

    @Then("the response JSON should contain owner with id {int} and firstName {string} and lastName {string}")
    public void the_response_json_should_contain_owner_with_id_and_firstName_and_lastName(Integer ownerId, String firstName, String lastName) {
        Assertions.assertEquals(ownerId.intValue(), response.jsonPath().getInt("id"),
                "Owner id in response does not match");
        Assertions.assertEquals(firstName, response.jsonPath().getString("firstName"),
                "Owner firstName in response does not match");
        Assertions.assertEquals(lastName, response.jsonPath().getString("lastName"),
                "Owner lastName in response does not match");
    }

    @Then("the response JSON should contain owner with id {int} and firstName {string}")
    public void the_response_json_should_contain_owner_with_id_and_firstName(Integer ownerId, String firstName) {
        Assertions.assertEquals(ownerId.intValue(), response.jsonPath().getInt("id"),
                "Owner id in response does not match");
        Assertions.assertEquals(firstName, response.jsonPath().getString("firstName"),
                "Owner firstName in response does not match");
    }

    @Then("the response JSON should contain pet with id {int}")
    public void the_response_json_should_contain_pet_with_id(Integer petId) {
        Assertions.assertEquals(petId.intValue(), response.jsonPath().getInt("id"),
                "Pet id in response does not match");
    }

    @Then("the response JSON should contain pet with name {string} and owner id {int}")
    public void the_response_json_should_contain_pet_with_name_and_owner_id(String name, Integer ownerId) {
        Assertions.assertEquals(name, response.jsonPath().getString("name"),
                "Pet name in response does not match");
        Assertions.assertEquals(ownerId.intValue(), response.jsonPath().getInt("owner.id"),
                "Pet owner id in response does not match");
    }

    @Then("the response JSON should contain pet with id {int} and name {string}")
    public void the_response_json_should_contain_pet_with_id_and_name(Integer petId, String name) {
        Assertions.assertEquals(petId.intValue(), response.jsonPath().getInt("id"),
                "Pet id in response does not match");
        Assertions.assertEquals(name, response.jsonPath().getString("name"),
                "Pet name in response does not match");
    }

    @Then("the response JSON should contain visit with id {int}")
    public void the_response_json_should_contain_visit_with_id(Integer visitId) {
        Assertions.assertEquals(visitId.intValue(), response.jsonPath().getInt("id"),
                "Visit id in response does not match");
    }

    @Then("the response JSON should contain visit with description {string} and pet id {int}")
    public void the_response_json_should_contain_visit_with_description_and_pet_id(String description, Integer petId) {
        Assertions.assertEquals(description, response.jsonPath().getString("description"),
                "Visit description in response does not match");
        Assertions.assertEquals(petId.intValue(), response.jsonPath().getInt("pet.id"),
                "Visit pet id in response does not match");
    }

    @Then("the response JSON should contain visit with id {int} and description {string}")
    public void the_response_json_should_contain_visit_with_id_and_description(Integer visitId, String description) {
        Assertions.assertEquals(visitId.intValue(), response.jsonPath().getInt("id"),
                "Visit id in response does not match");
        Assertions.assertEquals(description, response.jsonPath().getString("description"),
                "Visit description in response does not match");
    }

    @Then("the response JSON should be a non-empty list of pet types")
    public void the_response_json_should_be_a_non_empty_list_of_pet_types() {
        List<Map<String, Object>> petTypes = response.jsonPath().getList("$");
        Assertions.assertNotNull(petTypes, "Pet types list is null");
        Assertions.assertFalse(petTypes.isEmpty(), "Pet types list is empty");
        for (Map<String, Object> petType : petTypes) {
            Assertions.assertTrue(petType.containsKey("id"), "Pet type missing id");
            Assertions.assertTrue(petType.containsKey("name"), "Pet type missing name");
        }
    }
}