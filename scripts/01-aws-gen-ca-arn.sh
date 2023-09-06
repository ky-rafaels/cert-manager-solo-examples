# Generate CA config file
echo '''
{
   "KeyAlgorithm":"RSA_2048",
   "SigningAlgorithm":"SHA256WITHRSA",
   "Subject":{
      "CommonName":"relay-root-ca"
   }
}
''' > ca_config.json
# Create CA in ACM PCA
export REGION=us-east-2
export CA_ARN=$(aws acm-pca create-certificate-authority \
     --certificate-authority-configuration file://ca_config.json \
     --certificate-authority-type "ROOT" \
     --idempotency-token 01234567 \
     --region $REGION \
     --tags  Key=Name,Value=relay-root-ca| jq -r '.CertificateAuthorityArn')
# Example response payload 
# {
#   "CertificateAuthorityArn": "arn:aws:acm-pca:us-east-1:123456789:certificate-authority/123456789-debf-4513-89f7-c1834d5ffbd5"
# }

