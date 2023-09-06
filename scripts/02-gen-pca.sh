
# download Root CA CSR from AWS
aws acm-pca get-certificate-authority-csr \
    --region $REGION \
    --certificate-authority-arn $CA_ARN \
    --output text > relay-root-ca.csr

# Issue Root Certificate
ISSUE_CERTIFICATE_RESPONSE=$(aws acm-pca issue-certificate \
    --certificate-authority-arn $CA_ARN \
    --csr fileb://relay-root-ca.csr \
    --region $REGION \
    --signing-algorithm "SHA256WITHRSA" \
    --template-arn arn:aws:acm-pca:::template/RootCACertificate/V1 \
    --validity Value=3650,Type="DAYS" \
    --idempotency-token 1234567 \
    --output json | jq -r '.CertificateArn')

CERTARN=$ISSUE_CERTIFICATE_RESPONSE

# Download Certificate
aws acm-pca get-certificate \
    --certificate-authority-arn $CA_ARN \
    --certificate-arn $CERTARN \
    --region $REGION \
    --output text > relay-root-ca.pem

# Upload certificate to AWS
aws acm-pca import-certificate-authority-certificate \
    --certificate-authority-arn $CA_ARN \
    --region $REGION \
    --certificate fileb://relay-root-ca.pem

