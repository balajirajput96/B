# Workflow configuration

The former Azure Web App workflow was a generated placeholder for a Node.js application. This repository currently contains a static HTML/SQL assignment rather than a Node.js application, and it does not define an Azure Web App name or publish-profile secret. The placeholder workflow was removed so pushes do not run a guaranteed-failing deployment attempt.

If this repository is later converted into a Node.js application, restore a deployment workflow only after setting the actual `AZURE_WEBAPP_NAME`, `AZURE_WEBAPP_PACKAGE_PATH`, supported Node version, and `AZURE_WEBAPP_PUBLISH_PROFILE` repository secret. Do not commit publish profiles or other credentials.
