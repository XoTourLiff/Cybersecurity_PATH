"My-resources" allows users to make Exegol their own and customize it even further. This feature relies on a simple volume shared between the host and all exegol containers, and an advanced integration in the Exegol images directly. It allows users to enjoy their own tools that are not available in Exegol but also to customize their Exegol setup

The volume is accessible from the host at ~/.exegol/my-resources/ and from the containers (if the feature was left enabled at the container creation) at /opt/my-resources.


https://docs.exegol.com/images/my-resources
