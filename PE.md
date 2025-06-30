From Projects to Products

The USPTO IT Product Catalog, introduced in FY 2019, is an element of the New Ways of Working. In moving away from a project-based IT delivery structure to a product catalog, the USPTO seeks to:

Allow both the OCIO and its business customers to focus on the full spectrum of IT delivery across the USPTO
Link IT delivery to overall USPTO strategies and thematic priorities
Better align resource availability including capacity and funding resources, staff, and contractors
Enable decision making at the working level
Communicate the strategic vision and value proposition of a product
Articulate the plan for delivering the strategic vision
Communicate specific resource capacity requirements for delivery
Highlight risks and interdependencies to enable cross-product planning
Document technical boundaries of the product for clear accountability
The USPTO’s IT Product Catalog currently has 30 products aligned to one of four product lines: Patent Product Line, Trademark Product Line, Enterprise Business Product Line, and Enterprise Infrastructure Product Line. Each product is comprised of both legacy systems that the USPTO is stabilizing, maintaining, and operating and modern solutions that are being planned, in progress, or in production.   The USPTO has prepared initial product roadmaps with prioritized epics for each of the 30 products within the four product lines. Descriptions of each product line follow.

Patent Product Line. The Patent Product Line encompasses products and product components that both deliver and collect business value. Both internal and external stakeholders access the product line to manage the Patent application process through the entire Patent lifecycle, including filing, examination, appeals, search, international data exchange, fees, maintenance, and reporting. Some current product components are in containment, being stabilized, or scheduled for retirement once modernized systems are in production.
Trademark Product Line. The Trademark Product Line encompasses products and product components that both deliver and collect business value. Both internal and external stakeholders access the product line to manage the Trademark application process through the entire Trademark lifecycle, including, filing, examination, appeals, search, international data exchange, fees, maintenance, and reporting. Some current product components are in containment or being stabilized and scheduled for retirement once modernized solutions are in production.
Enterprise Business Product Line. The Enterprise Business Product Line encompasses products and product components that both deliver and collect business value. Both internal and external stakeholders access the product lines to manage fee collection and refunds, communications and information dissemination, financial management, procurement, budgeting, human resources, time and attendance, property and facility management, legal tools, and management of data, analytics, and associated reporting functions. Many of the IT solutions for this product line are configured and customized COTS and GOTS.
Enterprise Infrastructure Product Line. The Enterprise Infrastructure Product Line encompasses products and product components that focus on delivering value to internal users. The product line includes major infrastructure solutions that underlie the mission product lines (Patent and Trademark) and Enterprise Business. Products in this line cover end-user equipment (e.g., laptops, monitors, etc.), network, platform, security and disaster recovery, cloud, and IT innovations. Efforts to support this product line are more closely aligned to infrastructure operations, maintenance, and recovery.
We kicked off our annual IT planning effort in January with great success as teams and agency executives came together to plan and prioritize for the year ahead. The Annual IT planning board is a new entity that drives the final review and prioritization of enterprise-wide IT work. Such planning is designed to ensure the right people come together to optimize our planning in an Agile environment. Right now, there is a lot of activity around this effort, all customer-focused and outcome-driven.

To satisfy the escalating demand for patents and trademarks, we need to improve how we deliver enterprise IT. So, we've embarked on an innovation journey with customer value at its heart. The powerful strides we make today will ensure that the agency's IT systems are future-proof and ready for NextGen delivery.

This transformation revolves around three key efforts aimed at providing greater enterprise value: stabilization, modernization, and governance. Under the umbrella of these efforts are 13 teams, with representatives from across the agency, working on 19 interdependent initiatives.

As Director Iancu said, "Our legacy systems are old and it is time…well beyond time, to undertake a fundamental modernization effort..." To date, we have prioritized 26 mission critical systems at risk of failure, and made a roadmap for their stabilization. Though there is more work to do, we've made great progress toward a more stable IT infrastructure.

A stable infrastructure provides a solid foundation for modernization. So as we stabilize, we are also taking a comprehensive look at our current and future IT needs, and freeing up resources to seize new opportunities.

Considering the rate of innovation, a modern enterprise IT infrastructure becomes quickly outdated without proper governance. To that end, in addition to stabilizing and modernizing, we are looking at possible reforms in planning and budgeting, procurement, our SDLC, maturing our Agile practices, and more.

Align
 In an effort to align Product Teams to the technology, development, security, and operations vision, teams will use the reference implementations for cloud solutions implementation.

Review this page in its entirety. It provides a complete picture of the high-level Enterprise Architecture, Target AWS Architecture, and various guidelines to help teams align.
If your team cannot align with the Target State Architecture, please contact the BPDO Architects so any issues can be resolved.   
If you have already started coding and are not aligned with the Target State Architecture, please contact the BPDO Architects to discuss transitioning your existing project to use one of the reference implementations.
Start with AWS for general application development. USPTO has the largest footprint, most experience, target platforms and data gravity.
Use Azure for Microsoft related COTS products, if AWS cannot be used.
Use GCP for SaaS services, like AI, where GCP is a market leader.
USPTO is not attempting cloud portability by default, unless there is an explicit business requirement.
Target Architecture Guidelines
Summary: The following are the defaults. Deviations must be discussed with the BPDO Architects for BPDO Product Teams and the Enterprise Architecture Division for all other Product Teams.

General: Cloud Native, Fully Managed Services first and exceptions should be discussed/approved.
Architecture: Domain Driven Microservices.
Cloud Environment: AWS Cloud. USPTO is not targeting multi-cloud unless there is a specific business need.
Source Code Repository: Git using GitLab
Pipeline Tool: GitLab Pipelines 
“Binary” Repository: Nexus 
Dependency Proxy: Nexus : Maven, NPM, Docker, etc. must be pulled through Nexus virtual repositories.
Container Orchestration: Services should be deployed as Containers into AWS ECS (not EKS)
Serverless: AWS Lambda 
Software Composition Analysis: Nexus Lifecycle
Authentication: Okta using the OIDC  pattern
Authorization: OAuth2 via Okta Authorization Servers 
Databases: AWS Relational Database Recommendations and Data Migration Resources
Observability / APM and Logging: Splunk/CloudWatch
Cloud Infrastructure: Must be fully provisioned via Infrastructure-as-Code using Terraform / Ansible
Operating System: Amazon Linux or Rocky8 (RHEL will no longer be supported for cloud starting Jan 1, 2024 with no more updates starting October 1, 2023)
Front-End Style/Design: USPTO Design System 
AWS Target State Architecture Patterns
For detailed AWS implementation patterns for the most common architectures visit: AWS Target State Architecture Patterns


Stabilization		
Stabilizing our infrastructure and legacy systems will minimize emergency work and reduce stress for you and your team. It will result in fewer system outages and issues, meaning we can focus on new and better ways of doing business, rather than fixing old and outdated systems

 Modernization
Modernizing means future-proofing and streamlining our systems and processes to address customer needs more efficiently. It means giving people the best tools to provide customers the best products and services for their fees (as we strive to support the agency mission of awarding patents and issuing trademarks)
Governance
Properly governing our stable and modern IT ecosystem means prioritizing work and reducing bureaucracy. It also means pushing responsibility to the most appropriate levels to create a nimble environment where decision making rests in the hands of the most capable and appropriate leaders and teams


New Way of Work (NWoW)
What is NWoW?
New Ways of Working (NWoW) is a set of best practices and concepts aimed at transforming the traditional ways of working within an organization to provide better business outcomes. NWoW emphasizes agile, lean, and automated processes to enable teams to deliver value more efficiently and effectively. It involves a shift towards product-centric teams, cross-functional collaboration, and a focus on delivering business value over velocity.

Why is NWoW important?
The concept of New Ways of Working is essential because it brings about significant improvements in how an organization operates and delivers its products or services. By adopting NWoW practices, organizations can achieve the following benefits:

Reduction in non-value-added work: NWoW helps identify and eliminate unnecessary tasks, leading to more efficient workflows.
Autonomous, empowered teams: Product-centric teams become more self-reliant and empowered to make decisions, resulting in faster and better outcomes.
Value-oriented approach: NWoW encourages teams to focus on delivering business value to customers rather than simply increasing speed.
Improved lead time and feedback frequency: Shorter iterations and continuous feedback loops enable faster response to changes and customer needs.
Who should be involved in NWoW?
For successful implementation of New Ways of Working, various stakeholders should be involved in the process:

Leadership: Top-level leaders should drive the adoption of NWoW best practices and provide support and resources for the transformation.
Product Owners: They play a critical role in defining the product vision and roadmap, aligning with business objectives, and prioritizing work items.
Scrum Masters: They facilitate agile ceremonies and ensure that the team adheres to agile principles and values.
Cross-functional Teams: These teams, consisting of individuals with diverse skills, collaborate to deliver valuable products.
DevSecOps Experts: They integrate security measures into the development process to ensure secure and reliable products.
Agile Coaches and Product Aligned Coaches: These coaches provide guidance and mentorship to teams during the transformation journey.
By involving these key players, organizations can create a collaborative an


To accelerate team velocity, improve resilience and improve collaboration we have created detailed AWS implementation patterns for our most common architectures.


https://prod-cicm.uspto.gov/gitlab/groups/enterprise-community/-/wikis/Containers/ECS-Nexus-Production-Best-Practices


https://prod-cicm.uspto.gov/gitlab/groups/enterprise-community/-/wikis/Containers/Copy-Container-from-Nexus-to-ECR


We have created an ECR repository called www-drupal : https://139332004453-pzrpqncl.us-east-1.console.aws.amazon.com/ecr/repositories/private/139332004453/www-drupal?region=us-east-1
The pipeline will create docker images every time it runs and push it there. For now, this will only be used for running tests. Later, we will deploy the site as a container from these images. The pipeline will also push the image to Nexus but that's just for artifact tracking purposes. ADP wants us to use ECR for deployments.
For prod, we will create another ECR repo of the same name. And we will do these things:

Our pipeline will push the image to both Nexus release-candidate repo and lab ECR
When we are ready to promote, the promote job in the pipeline will move the image in Nexus from release-candidate to release repo. And it will also push the image to the prod ECR
Our ECS configuration in both lab and prod will be configured to always pull from ECR instead of Nexus. This is because Nexus kept going down due to load so they sent an email saying we need to pull from ECR.
###############################################################################################

USPTO_TargetState_ReferenceArchitectureV3.1.pptx
This deck covers following parts of our architecture guidelines

Guidelines
TSA Adoption and Acceleration – Stories from the War Room
High Level Target State Architecture
Microservices Reference Architecture
Internal Facing Applications
Public Facing Applications
Hybrid (Internal/Public) Applications
OKTA Integration using Sidecar pattern
Frontend/UI
Serverless Workloads
Batch Workloads
Secure Public File Transfer using CloudFront and Lambda@Edge with Okta
Eventhub Reference Implementation
Resiliency and Chaos Engineering
HA/DR Configuration for Applications based on Tiers
Observability

For a comprehensive understanding of recommended patterns and practices for migrating/operating cloud native applications, please refer to
Developer Journey - SharePoint
USPTO Architecture Guardrails and Guidelines - SharePoint



NWOW 


USPTO GitLab Reference Pipeline Adoption Guide
Overview
The USPTO GitLab Reference Pipelines standardize implementation of CI/CD process by providing modular, reusable components that handle essential tasks such as building, testing, security scanning, and deployment. By leveraging the reference pipelines, teams can focus on their specific project needs while ensuring compliance and security standards are consistently maintained.
Key Features
• Assured Compliance with USPTO DevSecOps Guardrails
• Adaptive Integration with Modular Components
• Accelerated Discovery with GitLab CI/CD Catalog

ECC Reference Pipeline Checklist:




Items
Yes/No
Response




1
Product team has dedicated DevSecOps Engineer OR POC
Yes/No
DevSecOps Enginner /POC Name:


2
Gitlab code Checked in and ready for Ref Pipeline
Yes/No



3
Service Account Instructions
Yes/No



4
Service Account SonarQube/Nexus 3/Nexus IQ onboarding
Yes/No



5
Technologies:   a. Maven   b. Container   c. Terraform   d. webapp   e. DotNet   f. NPM

Yes/No



6
If AWS Runners – Service Catalog
Yes/No



7
If On-Prem Runners
Yes/No



8

Functional Test  a. Selenium-Maven-Integration  b. SOAP UI

Yes/No



9
Cybersecurity  a. DAST

Yes/No



10
Performance Testing  a. Okta jMeter

Yes/No




Getting Started
Pre-requisites Before adopting the reference pipeline, teams must complete the following steps:

Cloud Intake Dojo - Completion of this process is mandatory.
GitLab Runner Configuration - Ensure that your On-Prem or AWS GitLab runner is properly set up.
Service Account Setup - Verify that required service accounts for SonarQube, NXRM, and Nexus Lifecycle have been onboarded.
Project Access Token - Create a project access token with api, read_repository, and write_repositoryscopes.
Secure Credential Storage - Follow the guidelines for securely storing credentials. More details can be found here.

Adoption Steps


Create a New Branch (this can be called something along the lines of Reference_pipeline_adoption)


Include the Reference Pipeline

If you already have .gitlab-ci.yml please rename it to .gitlab-ci-old.yml and create a New .gitlab-ci.yml and Update to have the following code:




include:
  - project: enterprise-community/gitlab-templates/pipelines
    ref: "4.4.1" # check https://prod-cicm.uspto.gov/gitlab/enterprise-community/gitlab-templates/pipelines/-/tags for the latest tag
    file: templates/reference-pipeline.yml


Enable the appropriate submodules, by setting the variable associated with that submodule e.g. USE_MAVEN: true

Update GitLab Configuration

Modify the variables in the .gitlab-ci.yml file as per your project requirements. Most teams will need to set variables like SERVICE_NAME or anything that uses a secret. In order to see what variables can be set and their defaults, check the reference pipeline template and the submodules you are using.
Commit the changes to your test branch.


Once your pipeline is working, you can merge it into master and use it for your development going forward.

Support and Feedback
Finding Help
Reference Pipeline Maintainer - Contact information for the maintainer can be found in the README.md file of the reference pipeline template project.

ECC Contribution Guide
For feedback or contributions, engage with ECC through the ECC contribution guide available here.
Join discussions via the ECC Teams channel here.
If additional support is needed, reach out to TDD to schedule an onboarding session with Reference Pipeline Architects.
