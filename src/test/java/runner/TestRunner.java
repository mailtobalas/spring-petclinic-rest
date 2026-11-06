=package org.springframework.samples.petclinic.rest;

import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@io.cucumber.junit.platform.engine.CucumberOptions(
    plugin = {"pretty", "html:target/cucumber-reports/cucumber.html"},
    glue = {"org.springframework.samples.petclinic.rest.steps"}
)
public class CucumberTestRunner {
}