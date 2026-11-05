=package org.springframework.samples.petclinic.rest.steps;

import io.cucumber.java.en.*;
import io.restassured.response.Response;
import io.restassured.http.ContentType;
import org.springframework.samples.petclinic.rest.client.PetclinicApiClient;

import java.util.Map;
import java.util.HashMap;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class PetclinicApiStepDefinitions {

    private final PetclinicApiClient apiClient = new PetclinicApiClient();
    private Response response;
    private Map<String, Object> requestBody;

    @Given("the API base URL is configured")
    public void the_api_base_url_is_configured() {
        apiClient.configureBaseUrl();
    }

    @Given("the following owner data:")
    public void the_following_owner_data(io.cucumber.datatable.DataTable dataTable) {
        requestBody = new HashMap<>();
        Map<String, String> map = dataTable.asMap(String.class, String.class);
        requestBody.putAll(map);
    }

    @Given("the following pet data:")
    public void the_following_pet_data(io.cucumber.datatable.DataTable dataTable) {
        requestBody = new HashMap<>();
        Map<String, String> map = dataTable.asMap(String.class, String.class);
        requestBody.putAll(map);
    }

    @Given("the following visit data:")
    public void the_following_visit_data(io.cucumber.datatable.DataTable dataTable) {
        requestBody = new HashMap<>();
        Map<String, String> map = dataTable.asMap(String.class, String.class);
        requestBody.putAll(map);
    }

    @When("I send a GET request to {string}")
    public void i_send_a_get_request_to(String endpoint) {
        response = apiClient.get(endpoint);
    }

    @When("I send a POST request to {string} with the owner data")
    public void i_send_a_post_request_to_with_the_owner_data(String endpoint) {
        response = apiClient.post(endpoint, requestBody);
    }

    @When("I send a POST request to {string} with the pet data")
    public void i_send_a_post_request_to_with_the_pet_data(String endpoint) {
        response = apiClient.post(endpoint, requestBody);
    }

    @When("I send a POST request to {string} with the visit data")
    public void i_send_a_post_request_to_with_the_visit_data(String endpoint) {
        response = apiClient.post(endpoint, requestBody);
    }

    @When("I send a PUT request to {string} with the owner data")
    public void i_send_a_put_request_to_with_the_owner_data(String endpoint) {
        response = apiClient.put(endpoint, requestBody);
    }

    @When("I send a PUT request to {string} with the pet data")
    public void i_send_a_put_request_to_with_the_pet_data(String endpoint) {
        response = apiClient.put(endpoint, requestBody);
    }

    @When("I send a PUT request to {string} with the visit data")
    public void i_send_a_put_request_to_with_the_visit_data(String endpoint) {
        response = apiClient.put(endpoint, requestBody);
    }

    @When("I send a DELETE request to {string}")
    public void i_send_a_delete_request_to(String endpoint) {
        response = apiClient.delete(endpoint);
    }

    @When("I send a POST request to {string} with malformed JSON body")
    public void i_send_a_post_request_to_with_malformed_json_body(String endpoint) {
        // Sending invalid JSON string intentionally
        String invalidJson = "{ invalid json }";
        response = apiClient.postRawJson(endpoint, invalidJson);
    }

    @Then("the response status code should be {int}")
    public void the_response_status_code_should_be(Integer expectedStatusCode) {
        assertThat("Unexpected status code", response.statusCode(), is(expectedStatusCode));
    }

    @Then("the response JSON should contain owner with id {int} and lastName {string}")
    public void the_response_json_should_contain_owner_with_id_and_lastName(Integer id, String lastName) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("id", equalTo(id))
                .body("lastName", equalTo(lastName));
    }

    @Then("the response JSON should contain owner with lastName {string}")
    public void the_response_json_should_contain_owner_with_lastName(String lastName) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("lastName", equalTo(lastName));
    }

    @Then("the response JSON should contain pet with id {int} and name {string}")
    public void the_response_json_should_contain_pet_with_id_and_name(Integer id, String name) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("id", equalTo(id))
                .body("name", equalTo(name));
    }

    @Then("the response JSON should contain pet with name {string}")
    public void the_response_json_should_contain_pet_with_name(String name) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("name", equalTo(name));
    }

    @Then("the response JSON should contain visit with id {int} and description {string}")
    public void the_response_json_should_contain_visit_with_id_and_description(Integer id, String description) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("id", equalTo(id))
                .body("description", equalTo(description));
    }

    @Then("the response JSON should contain visit with description {string}")
    public void the_response_json_should_contain_visit_with_description(String description) {
        response.then()
                .assertThat()
                .contentType(ContentType.JSON)
                .body("description", equalTo(description));
    }

    @Then("no content is returned")
    public void no_content_is_returned() {
        assertThat("Expected empty response body", response.getBody().asString().trim(), isEmptyString());
    }
}