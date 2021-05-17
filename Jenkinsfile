podTemplate(containers: [
    containerTemplate(
        name: 'ruby',
        image: 'ruby:2.7',
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
    branch = getGitBranchName()

    git(branch: branch,
        credentialsId: 'github_end-to-end-tests',
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

    // Install ChromeDriver. Major version must match google-chrome-stable. Find current version
    // in Jenkins logs from the output of the above apt-get install command.
    // Find the latest version at https://sites.google.com/a/chromium.org/chromedriver/downloads
    // that matches major versions, then use that version here.
    //
    // This now automatically retrieves the version used by google-chrome-stable and sets the major version to a var.
    // chromedriver and google-chrome-stable minor versions may differ.
    // 2020-09-08: 85.0.4183.87
    chrome_version = sh(script: 'google-chrome-stable --version', returnStdout: true).trim().split(' ').last()
    chrome_major_version = chrome_version.substring(0,2)
    chromedriver_version = sh(
        script: "curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$chrome_major_version",
        returnStdout: true
        ).trim()

    sh """
        wget https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_linux64.zip
        unzip chromedriver_linux64.zip
        rm chromedriver_linux64.zip
        mv chromedriver /usr/bin/chromedriver
    """

    // Install gems
    sshagent(['github_api-integration-tests']) {
        sh '''
            mkdir ~/.ssh
            ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
        '''

        sh '''
            gem install bundler rake
            bundle update --bundler
            bundle install
        '''
    }

     withCredentials([file(credentialsId: 'browserstack_credentials', variable: 'browserstack_credentials_file')]) {
        sh '''
        echo "Grabbing Browserstack Credentials"
        set +x
        while read token ; do \
            key=$(echo $token | cut -d '=' -f1 | tr -d ' '); \
            value=$(echo $token | cut -d '=' -f2 | tr -d ' '); \
            sed -i -e "s/{$key}/$value/" .env.staging; \
        done < $browserstack_credentials_file
        set -x
        '''
    }
}

def test() {
    def result = null
    def taskName = "${env.JOB_NAME}".split('/').last()

    result = sh(script: "bundle exec rake jenkins:${taskName}", returnStatus: true)
    junit 'tmp/*.xml'

    if (result == 0) {
        currentBuild.result = 'SUCCESS'
    } else {
        currentBuild.result = 'FAILURE'

        // This directory should match the directory where snapshots from tests are saved to
        archiveArtifacts(artifacts: 'results/*')
    }

    return result
}

def getGitBranchName() {
    return scm.branches[0].name
}
