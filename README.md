<p align="center"><img width="1920" alt="header" src="https://github.com/HamaHama-Dev/pupmory/assets/77003554/87f597a3-e515-44fc-b1f2-38a1e9e809a2"></p>

<p align="center">
<a href="https://github.com/HamaHama-Dev/pupmory/pkgs/container/pupmory%2Fpupmory-backend"><img src="https://img.shields.io/badge/backend-1.0.0-white?label=pupmory-backend&logo=docker&logoColor=white&color=%232496ED&style=flat-square"></a>&nbsp;
<a href="https://github.com/HamaHama-Dev/pupmory/actions/workflows/build-n-publish.yml"><img src="https://img.shields.io/github/actions/workflow/status/HamaHama-Dev/pupmory/build-n-publish.yml?label=Docker%20Publish&logo=github&style=flat-square"></a>
</p>

## 🚀 Manual Deployment

Fill out all **curly brackets** in `deploy.sh`.

The following are required:
- `DB_URL`: Database endpoint
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password
- `MAIL_USERNAME`: Email SMTP username
- `MAIL_PASSWORD`: Email SMTP password
- `GPT_KEY`: OpenAI API key
- `AWS_REGION`: AWS region
- `S3_BUCKET`: AWS S3 bucket name
- `S3_ACCESS_KEY`: AWS S3 access key
- `S3_SECRET_KEY`: AWS S3 secret key
- `JWT_SECRET`: JWT secret key

Make sure `docker` is installed in your system then execute:
```
./deploy.sh
```
