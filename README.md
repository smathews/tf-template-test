# Terraform Project

This template is to be used by developers starting a new Terraform project or module. It includes
a basic skeleton for your project, providing unit-testing and CI/CD (TODO: CD).

When a pull request is opened or updated for an epic branch (feature branch), unit testing is run.
When a pull request to merge in the epic is opened against master, the unit tests are run as well as
acceptance tests. Unit testing for terraform includes tests that check the output of a Plan.
Acceptance tests will run any tests that run an Apply and check migration paths as well.

Create a new repository and select this for your template. When you have the new repository cloned
locally, follow the steps below to complete setup.

## 1. Turn on Travis CI

Find your repository in Travis and enable it. Default settings should be fine. You may need to run
`Sync account` for your new repository to show up.

[Workload Engineering Services Travis CI](https://travis.ibm.com/profile/workload-eng-services)

![Upload Key](/../../../wes-arch/blob/master/resources/wes-travis-ci.png?raw=true)

## 2. Setup Travis CLI and Login

This step is only needed once per system, you can skip this step if you've completed it before.

### 2.1 Install Travis

Follow instructions: [Travis Installation](https://github.com/travis-ci/travis.rb#installation)

### 2.2 Create GHE Token

Create a new Token in
[GHE Personal Access Tokens](https://github.ibm.com/settings/tokens).
For required permissions information see:
[Travis Github Oauth Scopes](https://docs.travis-ci.com/user/github-oauth-scopes/).

![Personal Access Token](/../../../wes-arch/blob/master/resources/personal-access-token.png?raw=true)

### 2.3 Login to Travis

With the token you created in the previous step, login to the Travis CLI:

```bash
smathews@SM-T14:~/Projects/github.ibm.com/mathewss/tf-sandbox$ travis login -X --github-token <ghe-token>
Enterprise domain: travis.ibm.com
Use travis.ibm.com as default endpoint? |yes| yes
Successfully logged in as mathewss!
```

## 3 Import API Key into Travis

### 3.1 Create or Obtain IBM Cloud API Key to run CI

For WES there is a testing Service ID in IBM Cloud, have an admin for the account create a new API
key for this repository.

### 3.2 Encrypt and Upload API Key

Every Travis CI instance (each repository) has an internal private key. Its public key can be used
to encrypt environment variables. For the tests to run Terraform, the API key from the previous step
will be needed as the the environment variable `API_KEY`.

Save the API key into `.travis.yml` using `travis encrypt` as shown below to set that variable
without compromising the key:

```bash
smathews@SM-T14:~/Projects/github.ibm.com/mathewss/tf-sandbox$ travis encrypt API_KEY="<ibmcloud_api_key>" --add
Detected repository as mathewss/tf-sandbox, is this correct? |yes| yes
Overwrite the config file /home/smathews/Projects/github.ibm.com/mathewss/tf-sandbox/.travis.yml with the content below?

This reformats the existing file.

---
env:
  global:
    secure: <encrypted-secret>

(y/N)
y
```

## 4. Generate and Upload ssh key pair for Travis

This is need for GO, when ran by Travis, to be able to get private repositories in IBM's GHE.

### 4.1 Generate Key

The default ssh key created by Ubuntu or OSX, stored in `~/.ssh/id_rsa`, will not work for this
step. Create an RSA ssh key of 4096 length:

```bash
smathews@SM-T14:~$ openssl genrsa -out deployment.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
..............................................................................................................................................................++++
........................................................++++
e is 65537 (0x010001)
```

And create the public key:

```bash
smathews@SM-T14:~$  ssh-keygen -f deployment.key -y > deployment.pub
```

### 4.2 Upload Private Key to Travis

Travis will need the key to access private repositories needed by the tests in this module
(tf-helper). Upload the key:

```bash
smathews@SM-T14:~/Projects/github.ibm.com/mathewss/tf-sandbox$ travis sshkey --upload ~/deployment.key
Key description: |Custom Key| smathews
Updating ssh key for mathewss/tf-sandbox with key from /home/smathews/deployment.key

Current SSH key: smathews
Finger print:    1e:57:7b:ac:6f:8b:1d:ec:12:53:60:74:18:a2:31:4f
```

### 4.3 Upload Public Key to GHE

Then upload the public key into [GHE Keys](https://github.ibm.com/settings/tokens).
This could be on your account, or ideally a functional ID's account.

![Upload Key](/../../../wes-arch/blob/master/resources/ssh-key-add-ghe.png?raw=true)

## 5. Create Tests

See README here: [Creating Tests](test/)

## 6. Create a README for this Project

Delete this file and create your README. Do not create a release with this README still in place!

## 7. Follow Release Process

[WES Release Process](TBD)

## 8. Updates

- One