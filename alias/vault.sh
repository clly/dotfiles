#!/bin/bash

unseal() {
    unseal=$(envy exec dev-vault bash -c 'printenv UNSEAL|base64 -d|keybase pgp decrypt')
    curl -XPUT https://localhost:8200/v1/sys/unseal --data-binary @- <<<"{\"key\":\"$unseal\"}"
}

rvault () { 
    VAULT_TOKEN=$(envy exec dev-vault bash -c 'printenv ROOT|base64 -d|keybase pgp decrypt');
    VAULT_TOKEN=$VAULT_TOKEN vault "$@"
}

token-run() {
    VAULT_TOKEN=$(envy exec dev-vault bash -c 'printenv ROOT|base64 -d|keybase pgp decrypt');
    VAULT_TOKEN=$VAULT_TOKEN "$@"
}
