pipeline {
  agent any

  environment {
    HOP_PROJECT = 'hopdbt'
    HOP_SCRIPT = '/usr/local/tomcat/webapps/ROOT/hop-run.sh'
    DOCKER_CONTAINER = 'hopcontainer-dataspeed'
    DBT_CONTAINER = 'dbt-dbt-dataspeed'
    DBT_PROJECT_DIR = '/dbt/dbt_dataspeed'
    REPO_LOCAL = 'D:/arruda-consulting/gondaski/arquivos_repo/gondaski_cicd'
  }

  stages {
    stage('Detectar pipelines modificados') {
      steps {
        script {
          def arquivos = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim().split('\n')
          def hopFiles = arquivos.findAll { it.endsWith('.hpl') || it.endsWith('.hwf') }

          if (hopFiles.size() == 0) {
            echo "Nenhum pipeline .hpl ou workflow .hwf modificado. Nada será executado."
          } else {
            hopFiles.each { filePath ->
              def tipo = filePath.endsWith('.hpl') ? 'Pipeline' : 'Workflow'
              def nome = filePath.tokenize('/').last().replace('.hpl', '').replace('.hwf', '')
              def relativePath = filePath.replace('projeto_hop/', '')

              //def ambientes = env.BRANCH_NAME == 'main' ? ['prd'] : ['dev']
              def ambientes = env.BRANCH_NAME

              ambientes.each { ambiente ->
                def hopAmbiente = ambiente.toUpperCase()
                //def dbtTarget = ambiente.toLowerCase()
                //def dbtTarget = 'dev'

                
                stage('Atualizar repositório local') {
                  steps {
                    bat """
                    cd ${env.REPO_LOCAL}
                    git pull origin ${ambientes}
                    """
                  }
                }
                
                //-e ${hopAmbiente} \\
                stage("Hop validação - ${hopAmbiente} - ${nome}") {
                  echo "Executando ${tipo} ${nome} no ambiente ${hopAmbiente}"
                  sh """
                    docker exec ${DOCKER_CONTAINER} bash -c "${HOP_SCRIPT} \\
                      -p ${HOP_PROJECT} \\
                      -f /usr/local/tomcat/webapps/ROOT/project/${relativePath} \\
                      -e hopdbt-dev \\
                      -c validate
                      -r local"
                  """
                }

                if (ambiente == 'prd') {
                  stage("Aprovação para PRD - ${nome}") {
                    input message: "Deseja executar ${tipo} '${nome}' em PRD?"
                  }
                }

                stage("Hop execução - ${hopAmbiente} - ${nome}") {
                  echo "Executando ${tipo} ${nome} no ambiente ${hopAmbiente}"
                  sh """
                    docker exec ${DOCKER_CONTAINER} bash -c "${HOP_SCRIPT} \\
                      -p ${HOP_PROJECT} \\
                      -f /usr/local/tomcat/webapps/ROOT/project/${relativePath} \\
                      -e hopdbt-dev \\
                      -r local"
                  """
                }
              }
            }
          }
        }
      }
    }
  }
}