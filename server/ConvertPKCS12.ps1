# Converts win-acme PemFiles to PKCS12 for use by Athena (Jetty keystore)
#
# Runs as win-acme script after each certificate renewal:
# ./ConvertPKCS12.ps1 theseus-aegis.com C:\Certificates <password>
#
# Requires openssl in PATH

param(
    [Parameter(Position=0,Mandatory=$true)]
    [string]$CertCommonName,
    [Parameter(Position=1,Mandatory=$true)]
    [string]$StorePath,
    [Parameter(Position=2,Mandatory=$true)]
    [string]$ExportPassword
)

openssl pkcs12 -export -out $StorePath\$CertCommonName-key.p12 -in $StorePath\$CertCommonName-chain.pem -inkey $StorePath\$CertCommonName-key.pem -password pass:$ExportPassword
