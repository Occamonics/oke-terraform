export PASSPHRASE="tttt"
export TF_VAR_private_key=`openssl rsa -in ~/.oci/d....y.pem -check -passin env:PASSPHRASE`
