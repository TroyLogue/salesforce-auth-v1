podTemplate(containers: [
    containerTemplate(
        name: 'ruby',
        image: 'ruby:latest',
        command: '',
        resourceRequestMemory: '512Mi',
        resourceLimitMemory: '1Gi',
        privileged: true,
        ttyEnabled: true,
    )
]) {
    node(POD_LABEL) {
        container('ruby') {
            stage('Checkout') {
                checkout()
            }

            stage('Build') {
                build()
            }

            stage('Test') {
                try {
                    test()
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'

                    error "Exception: $e"
                } finally {
                    echo 'Tests finished'
                }
            }
        }
    }
}

def checkout() {
    branch = 'master'

    git(branch: branch,
        credentialsId: 'github_ssh',
        url: 'git@github.com:unite-us/end-to-end-tests.git'
    )
}

def build() {
    // Install google chrome
    sh '''
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
        sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
        apt-get update -y
        apt-get install -y google-chrome-stable
    '''

    // Install ChromeDriver. Major version must match google-chrome-stable
    chromedriver_version = '79.0.3945.36'
    sh """
        wget https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_linux64.zip
        unzip chromedriver_linux64.zip
        rm chromedriver_linux64.zip
        mv chromedriver /usr/bin/chromedriver
    """

    // Install gems
    sh '''
        gem install bundler rake
        bundle update --bundler
        bundle install
    '''

    withCredentials([file(credentialsId: 'browserstack_credentials', variable: 'browserstack_credentials_file')]) {
        sh "cp '$browserstack_credentials_file' lib/browserstack_credentials.rb"
    }
}

def test() {
    def result = null

    withEnv(["browser=chrome_headless"]) {
        result = sh(script: "bundle exec rspec -t app_client_smoke", returnStatus: true)
    }

    // withEnv(["browser=chrome"]) {
    //     result = sh(script: "bundle exec rake local:by_tag[app_client_staging,chrome,app_client_smoke]", returnStatus: true)
    // }

    if (result == 0) {
        currentBuild.result = 'SUCCESS'
    } else {
        currentBuild.result = 'FAILURE'

        // This directory should match the directory where snapshots from tests are saved to
        archiveArtifacts(artifacts: 'results/*')
    }

    return result
}
