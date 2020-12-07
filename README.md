# Jenkins Workshop
> Project with examples of how to use Jenkins.

Project with examples of how to use Jenkins. This is a show down of capabilities of Jenkins with
 some examples. 
 
## Multi branches pipelines best practices

### Have a Standard Structure
It is essential to have the standard branching structure for your repositories. Whether it is your application code or 
infra code, having a standard branching will reduce the inconsistent configurations across different pipelines. Here
 a list of branching strategies that could be used:
* [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
* [Github Workflow](https://guides.github.com/introduction/flow/)

### Pull Request Vs Commit Triggers 
Try to use a PR based pipeline rather than commit based. If a code repo gets continuous commits it might overwhelm 
Jenkins with many builds.
Commit based triggers are supported in PR based discovery as well.

 
## Examples inside the project
The list of examples are the next:
* `01_only_tests` There is only two steps. In the first one, it is made a basic checkout of the code and then the
 code is run inside a docker image which has the same java version than the project needs to be able to run it. There
  is also shown how to se Environment variables 
* `02_tests_and_build` Very similar to previous example but in this one there is a Java build script. Even though
 Java can run commonds in parallel here is as well an example of how to run commands in parallel. These steps could
  be run in parallel with this instead of the current steps:
```groovy
stage('Build') {
    parallel {
        stage('Run Tests') {
            steps {
                sh './gradlew --no-daemon --info --build-cache --parallel test'
            }
        }

        stage('Run Build') {
            steps {
                sh './gradlew --no-daemon --info --build-cache --parallel build'
            }
        }
    }
}
```
* `03_tests_build_docker` In this example, apart from running the tests, like in the previous examples, the build is
 now done through Docker. The pipeline is using the Dockerfile located inside the folder /actuator and publishing to
  the some repository for future use. It gives as well a Tag to the build, so it is easy to recognize.
  
* `04_tests_build_deploy` This pipeline just do two steps different than previous one. Both of these steps are done
 in parallel in the Deploy stage. In the first one the commit get tagged with the same tag as the build has. In the
  second step the docker build is marked in the kubernetes deployment and then updating kubernetes the updated file. 
  Moreover, this two steps are executed only if the commit was done in the branch Development or
    Master and aiming to the specific enviroment depending of the tag, so a feature branch could not be deployed in. 
*`05_split_stages_for_manual_individual_call` This example is about having the same approach than in the previous one
 but giving the possibility to run each stage independently, manually and giving the parameters to run such stage.
    * `05_0_general` this is the pipeline that enclose all the stages. So, it will be run automatically depending if
     development or master branch got some commits. And also will give a full overview of all the steps run during
      the pipeline.
    * `05_1_tests` This pipeline take as parameter the branch to which the run have to be run. 
    * `05_2_build_docker` This pipeline take as parameters Tag, Image and Branch. Branch is a public parameter that
     can be used when running this pipeline manually, making possible to build a feature branch. Tag and Image
      parameters are hidden and only given from the general pipeline which will create the tag and image route. This
       pipeline will take care of the build and publish to the docker repository, moreover of tagging the commit for
        future reference of what was deployed.
    * `05_03_deploy` This pipeline take tag, image and environment as parameters, which will be given by the general
     pipeline or also manually all of them. It takes care that the deployment is been done to Kubernetes Cluster updating the
      kubernetes file of the project replacing the image name of the deployment file.

## Release History
* 0.0.1
    * Basic examples

## Meta

Francisco Estudillo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Links of Interest
* [Jenkins Documenation](https://www.jenkins.io/doc/pipeline/tour/hello-world/)
* [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
* [Github Workflow](https://guides.github.com/introduction/flow/)
