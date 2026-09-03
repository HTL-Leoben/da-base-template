# Jenkins

The provided `Jenkinsfile` can be used to create a Jenkins build environment where all build depenencies are satisfied thorugh the used Docker image.

## Trigggers

The `Jenkinsfile` provided can be used staying in its current path and than this path given in the Jenkins GUI under the Pipeline definition for "Pipeline script from SCM". It is also recommended to select "Poll SCM" as trigger.

## Dependencies

It requires a linux based node with the label docker and docker installed onto this node. There are different dependencies to meet depending on which function you want to use of this script. The script is per default compliant with a normal Jenkins install. To use the compression choice of [7z](https://www.7-zip.org/) it needs to be installed on the node the stages are executed on. To use the function of sending emails, the [Email Extension Plugin](https://plugins.jenkins.io/email-ext/) needs to be installed and configured on the Jenkins host.

## Build Retention

The defaults for discarding builds are set like in the following table.

| Name | Required | Default |
| - | - | - |
| Days to keep builds | `false` | 7 |
| Max number of builds to keep | `false` | 10 |
| Days to keep artifacts | `false` | 7 |
| Max number of build to keep with artifacts | `false` | 10 |
| Remove last build | `false` | no |

## Inputs

The `Jenkinsfile` supports building the PDF, Spellcheck and bare LaTeX file depending on if the option for it was set to `true`. Some can also manipulate the archive format, directories, docker settings and mail options through the provided inputs. If any setting is different from the defaults provided down below it is recommended to set the corresponding settings as defaults in the repositories own `Jenkinsfile` instead of setting it as inputs in the GUI.

| Name | Required | Description | Default |
| - | - | - | - |
| BUILD_PDF | `false` | Build PDF output | true |
| BUILD_SPELLCHECK | `false` | Build spellcheck output | false |
| BUILD_TEX | `false` | Build LaTeX output | false |
| ARCHIVE_FORMAT | `false` | Archive type to use. Avaible options are: zip, tar.gz, 7z | zip |
| TEMPLATE | `false` | Name of the folder in which the template files lie | da-base-template |
| SOURCE_DIR | `false` | Name of the folder in the repository in which the diploma thesis lies | Diplomarbeit |
| RECEIVING_MAILS | `false` | Comma seperated list of the receiving mail addresses to which the archive of the diploma thesis is sent to | - |
| MAIL_BODY | `false` | Body of the email sent to the receiving mail addresses | `git log -1 --pretty=%B` |
| SEND_UNCOMPRESSED | `false` | Send uncompressed files instead of an archive | false |
| DOCKER_REGISTRY | `false` | URL of the Docker registry | docker.io |
| DOCKER_NAMESPACE | `false` | Name of the Docker namespace | bytebang |
| DOCKER_IMAGE | `false` | Name of the Docker image | htlle-da-builder |
| DOCKER_TAG | `false` | Name of the Docker tag | latest |

**Author:** [Marko Schrempf](https://github.com/bitsneak)