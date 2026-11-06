=package org.springframework.samples.petclinic.rest.steps;

import io.cucumber.java.en.*;
import io.restassured.response.Response;
import org.springframework.samples.petclinic.rest.client.ApiClient;

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class PetclinicStepDefinitions {

    private final ApiClient apiClient = new ApiClient();
    private Response response;
    private Map<String, Object> requestBody;

    @Given("the API base URL is configured")
    public void the_api_base_url_is_configured() {
        // Base URL is configured in ApiClient constructor
    }

    // Owner steps

    @When("the client requests GET /owners/{int}")
    public void the_client_requests_get_owner_by_id(Integer ownerId) {
        response = apiClient.getOwnerById(ownerId);
    }

    @Then("the response status code is {int}")
    public void the_response_status_code_is(Integer statusCode) {
        assertThat(response.statusCode(), is(statusCode));
    }

    @Then("the response contains owner with id {int}")
    public void the_response_contains_owner_with_id(Integer ownerId) {
        response.then()
                .statusCode(200)
                .body("id", equalTo(ownerId));
    }

    @Then("the response contains error message {string}")
    public void the_response_contains_error_message(String message) {
        response.then()
                .body("error", containsString(message));
    }

    @When("the client creates an owner with:")
    public void the_client_creates_an_owner_with(io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        requestBody.put("firstName", data.get("firstName"));
        requestBody.put("lastName", data.get("lastName"));
        requestBody.put("address", data.get("address"));
        requestBody.put("city", data.get("city"));
        requestBody.put("telephone", data.get("telephone"));
        response = apiClient.createOwner(requestBody);
    }

    @Then("the response contains owner with firstName {string} and lastName {string}")
    public void the_response_contains_owner_with_firstName_and_lastName(String firstName, String lastName) {
        response.then()
                .statusCode(anyOf(is(200), is(201)))
                .body("firstName", equalTo(firstName))
                .body("lastName", equalTo(lastName));
    }

    @Then("the response contains validation error for {string}")
    public void the_response_contains_validation_error_for(String field) {
        response.then()
                .statusCode(400)
                .body("errors.field", hasItem(field));
    }

    @Given("an owner exists with id {int}")
    public void an_owner_exists_with_id(Integer ownerId) {
        response = apiClient.getOwnerById(ownerId);
        assertThat("Owner with id " + ownerId + " should exist", response.statusCode(), is(200));
    }

    @When("the client updates owner with id {int} with:")
    public void the_client_updates_owner_with_id_with(Integer ownerId, io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        requestBody.put("firstName", data.get("firstName"));
        requestBody.put("lastName", data.get("lastName"));
        requestBody.put("address", data.get("address"));
        requestBody.put("city", data.get("city"));
        requestBody.put("telephone", data.get("telephone"));
        response = apiClient.updateOwner(ownerId, requestBody);
    }

    @When("the client deletes owner with id {int}")
    public void the_client_deletes_owner_with_id(Integer ownerId) {
        response = apiClient.deleteOwner(ownerId);
    }

    // Pet steps

    @When("the client requests GET /pets/{int}")
    public void the_client_requests_get_pet_by_id(Integer petId) {
        response = apiClient.getPetById(petId);
    }

    @Then("the response contains pet with id {int}")
    public void the_response_contains_pet_with_id(Integer petId) {
        response.then()
                .statusCode(200)
                .body("id", equalTo(petId));
    }

    @When("the client creates a pet with:")
    public void the_client_creates_a_pet_with(io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        requestBody.put("name", data.get("name"));
        requestBody.put("birthDate", data.get("birthDate"));
        if (data.get("typeId") != null && !data.get("typeId").isEmpty()) {
            try {
                requestBody.put("typeId", Integer.parseInt(data.get("typeId")));
            } catch (NumberFormatException ignored) {}
        }
        if (data.get("ownerId") != null && !data.get("ownerId").isEmpty()) {
            try {
                requestBody.put("ownerId", Integer.parseInt(data.get("ownerId")));
            } catch (NumberFormatException ignored) {}
        }
        response = apiClient.createPet(requestBody);
    }

    @Then("the response contains pet with id >= {int}")
    public void the_response_contains_pet_with_id_greater_or_equal(Integer minId) {
        response.then()
                .statusCode(anyOf(is(200), is(201)))
                .body("id", greaterThanOrEqualTo(minId));
    }

    @Given("a pet exists with id {int}")
    public void a_pet_exists_with_id(Integer petId) {
        response = apiClient.getPetById(petId);
        assertThat("Pet with id " + petId + " should exist", response.statusCode(), is(200));
    }

    @When("the client updates pet with id {int} with:")
    public void the_client_updates_pet_with_id_with(Integer petId, io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        requestBody.put("name", data.get("name"));
        requestBody.put("birthDate", data.get("birthDate"));
        if (data.get("typeId") != null && !data.get("typeId").isEmpty()) {
            try {
                requestBody.put("typeId", Integer.parseInt(data.get("typeId")));
            } catch (NumberFormatException ignored) {}
        }
        if (data.get("ownerId") != null && !data.get("ownerId").isEmpty()) {
            try {
                requestBody.put("ownerId", Integer.parseInt(data.get("ownerId")));
            } catch (NumberFormatException ignored) {}
        }
        response = apiClient.updatePet(petId, requestBody);
    }

    @When("the client deletes pet with id {int}")
    public void the_client_deletes_pet_with_id(Integer petId) {
        response = apiClient.deletePet(petId);
    }

    // Visit steps

    @When("the client requests GET /visits/{int}")
    public void the_client_requests_get_visit_by_id(Integer visitId) {
        response = apiClient.getVisitById(visitId);
    }

    @Then("the response contains visit with id {int}")
    public void the_response_contains_visit_with_id(Integer visitId) {
        response.then()
                .statusCode(200)
                .body("id", equalTo(visitId));
    }

    @When("the client creates a visit with:")
    public void the_client_creates_a_visit_with(io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        if (data.get("petId") != null && !data.get("petId").isEmpty()) {
            try {
                requestBody.put("petId", Integer.parseInt(data.get("petId")));
            } catch (NumberFormatException ignored) {}
        }
        requestBody.put("visitDate", data.get("visitDate"));
        requestBody.put("description", data.get("description"));
        response = apiClient.createVisit(requestBody);
    }

    @Then("the response contains visit with id >= {int}")
    public void the_response_contains_visit_with_id_greater_or_equal(Integer minId) {
        response.then()
                .statusCode(anyOf(is(200), is(201)))
                .body("id", greaterThanOrEqualTo(minId));
    }

    @Given("a visit exists with id {int}")
    public void a_visit_exists_with_id(Integer visitId) {
        response = apiClient.getVisitById(visitId);
        assertThat("Visit with id " + visitId + " should exist", response.statusCode(), is(200));
    }

    @When("the client updates visit with id {int} with:")
    public void the_client_updates_visit_with_id_with(Integer visitId, io.cucumber.datatable.DataTable dataTable) {
        Map<String, String> data = dataTable.asMaps().get(0);
        requestBody = new HashMap<>();
        if (data.get("petId") != null && !data.get("petId").isEmpty()) {
            try {
                requestBody.put("petId", Integer.parseInt(data.get("petId")));
            } catch (NumberFormatException ignored) {}
        }
        requestBody.put("visitDate", data.get("visitDate"));
        requestBody.put("description", data.get("description"));
        response = apiClient.updateVisit(visitId, requestBody);
    }

    @When("the client deletes visit with id {int}")
    public void the_client_deletes_visit_with_id(Integer visitId) {
        response = apiClient.deleteVisit(visitId);
    }
}