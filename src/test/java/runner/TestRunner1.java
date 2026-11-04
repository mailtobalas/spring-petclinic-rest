=package org.springframework.samples.petclinic.rest;

import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;
import io.cucumber.junit.platform.engine.Cucumber;

@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@Cucumber
public class CucumberTestRunner {
}