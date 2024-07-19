<img src="./craigify_1.webp" alt="app-image" style="width: 580px; height: 700px;">

# craigify
![Production](https://github.com/tmtarpinian/craigify/actions/workflows/production.yml/badge.svg)
![Coverage](badge.svg)
<br>
### Table of Contents

- [Description](#description)
- [Dependencies](#dependencies)
- [PreRequisites](#prerequisites)
- [Run](#Run)
- [Resources](#Resources)
    - [Application Controller](#Application)
    - [User Controller](#Users)
    - [Beds Controller](#Beds)
    - [Plants Controller](#Plants)
    - [Harvests Controller](#Harvests)
- [Contributing](#Contributing)
- [Code of Conduct](#Conduct)
- [License](#license)
- [Maintainers](#Maintainer(s))

---

## Description
Set of Ruby scripts for scraping craigslist, pushing results to text or email via AWS SNS

## Dependencies
The following requirements are necessary to run this application:
- Docker (ideally Docker Desktop)
- AWS account

## Dependencies
The following AWS resources will need to be built (terraform forthcoming):
- 2 lambda functions, with security groups
- cloudwatch
- sns pool
- elasticache instanct with redis cluster
- Eventbridge triggers

TODO: illustrate resources

## Run
  V.0.1
  - Fire up docker locally
  - build the image: `docker compose build`
  - start a container: `docker compose up`
  - upload the zipped files created from the build to your lambda functions

  TODO: terraform code to build the lambda functions and peripheral aws resources, and upload zipped files to S3

## Contributing
Bug reports submitted as issues or pull requests are welcome on GitHub at https://github.com/tmtarpinian/craigify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant Code of conduct.

## Conduct
Everyone using and interacting in Craigify's code
bases, issue trackers, chat rooms and/or mailing lists is expected to follow the [Code of conduct](./CODE_OF_CONDUCT.md).

## License
Copyright © 2024 Trevor Tarpinian

The app is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
---

## Maintainer(s)

| <img src="https://avatars.githubusercontent.com/u/58449380?s=400&u=7aafe57b3932491248aff945a3cbee94e333bbc0&v=4" alt="tmtarpinian" style="border-radius: 90px; width: 100px; height: 100px;"> |
| :------------- | 
|[@tmtarpinian](https://github.com/tmtarpinian) |