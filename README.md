# Table of Contents

* [Docker: Your First Project](#docker-your-first-project)
* [My Notes](#my-notes)

# Docker Your First Project
This is the repository for the LinkedIn Learning course `Docker: Your First Project`. The full course is available from [LinkedIn Learning][URL-lil-course].

![Docker: Your First Project][URL-lil-thumbnail]

Docker has a steep learning curve, but is required for most current development environments. Streamlining how you build, share, and run applications can increase your development team’s productivity and let developers focus on the code. This course with instructor Shelley Benhoff provides a step-by-step guide for developers to work with Docker locally. Join Shelley as she takes you through a real-world project and learn how to set up your development environment, write a Dockerfile, build and manage custom images, and run your Docker containers.

## Instructions
This repository has branches for each of the videos in the course. You can use the branch pop up menu in github to switch to a specific branch and take a look at the course at that stage, or you can add `/tree/BRANCH_NAME` to the URL to go to the branch you want to access.

## Branches
The branches are structured to correspond to the videos in the course. The naming convention is `CHAPTER#_MOVIE#`. As an example, the branch named `02_03` corresponds to the second chapter and the third video in that chapter. 
Some branches will have a beginning and an end state. These are marked with the letters `b` for "beginning" and `e` for "end". The `b` branch contains the code as it is at the beginning of the movie. The `e` branch contains the code as it is at the end of the movie. The `main` branch holds the final state of the code when in the course.

When switching from one exercise files branch to the next after making changes to the files, you may get a message like this:

    error: Your local changes to the following files would be overwritten by checkout:        [files]
    Please commit your changes or stash them before you switch branches.
    Aborting

To resolve this issue:
	
    Add changes to git using this command: git add .
	Commit changes using this command: git commit -m "some message"

## Installing
1. To use these exercise files, you must have the following installed:
	- Docker Desktop
    - VSCode
    - Git Bash
2. Clone this repository into your local machine using the Git Bash command `git clone https://github.com/LinkedInLearning/docker-your-first-project-4485003.git`
3. Switch between branches using the Git Bash command `git checkout CHAPTER#_MOVIE#`
4. View all available branches using the Git Bash command `git branch`

### Instructor
Shelley Benhoff


Senior Developer Experience Manager at Docker, Instructor, and Author

Check out my other courses on [LinkedIn Learning][URL-instructor-home].

[URL-lil-course]: https://www.linkedin.com/learning/docker-your-first-project
[URL-lil-thumbnail]: https://media.licdn.com/dms/image/D560DAQHjKrL64jLnaA/learning-public-crop_675_1200/0/1701991509593?e=2147483647&v=beta&t=VwonMpzrnmxJk07lG2SRqLwwR2gqj7vPCsJp51Ryu7k
[URL-instructor-home]: https://www.linkedin.com/learning/instructors/shelley-benhoff


# My Notes
### Building docker image from dockerfile (Branch 02_02)

```bash
# Branch 02_02
docker build -t docker-project .
```

#### **Core Build Concepts**

- **The Syntax**: The basic structure is `docker build [OPTIONS] PATH | URL`.
- **Build Context**: This refers to the set of files located at the specified path or URL used to build the image.
- **Default Behavior**: Running `docker build .` uses the current root directory as the context and assumes the Dockerfile is located there by default.

#### **Essential Flags & Options**

- **`-f` (File)**: Allows you to specify a path to a different Dockerfile if it isn't in the root directory. This is useful for managing environment-specific files like QA, staging, or production.
- **`-force-rm`**: Automatically removes intermediate containers created for each instruction (e.g., `RUN`, `COPY`), even if the build fails.
- **`-rm=true`**: The default behavior that removes intermediate containers after a successful build, but keeps them if the build fails to allow for debugging.
- **`-no-cache`**: Forces Docker to ignore previously built image layers and rebuild the entire image from scratch. While slower, this is helpful for troubleshooting errors or ensuring external dependencies are updated.

#### **Best Practices**

- **Caching**: Docker uses a cache to speed up builds by reusing successful layers. It is recommended to bypass this only when encountering errors or needing a "clean" build.
- **Troubleshooting**: You can use the `-help` option with any Docker command to view a full list of available flags and documentation.

### Searching for images (Branch 03_01)

```bash
# Searches Docker Hub for images matching the term "python" and
# displays the results in a standard table.
docker search python

# Restricts search results to only show verified, official images
# maintained by the Docker team or authorized organizations.
docker search --filter is-official=true python

# Filters the results to only include images that have received at
# least 100 stars from the community.
docker search --filter stars=100 python

# Filters for images that are built automatically from a source code
# repository (note: the value is typically true or false).
docker search --filter is-automated=true python

# Multiple filters
docker search --filter is-official=true \       
--filter stars=10 \
--filter is-automated=false python

# Limits the output to the top 4 search results instead of the default 25.
docker search --limit 4 python

# Prevents the truncation of the description field, allowing you to
# read the full text in the terminal.
docker search --no-trunc python

# Uses a custom template to display only the image name and its
# full description without table headers.
docker search --format "{{.Name}}: {{.Description}}" --no-trunc python

# Generates a clean, customized table layout highlighting the specific
# metadata fields you want to compare.
docker search --format "table {{.Name}}\t{{.Description}} \
\t{{.IsOfficial}}\t{{.StarCount}}" \
 --no-trunc python
```

### Working with custom images (Branch 03_02)

```bash
docker image ls --all

# Untrucated all images
docker image ls --no-trunc

# Displays only the numeric Image IDs, which is ideal for 
# piping into other commands or scripts.
docker image ls --quiet

# Lists images along with their immutable SHA256 hashes to 
# ensure content-addressable integrity.
docker image ls --digests

# Filters the list to show only images where the repository name
# starts with "python".
docker image ls --filter reference=python*

# Shows images that were created chronologically before the 
# "docker-project" image was built.
docker image ls --filter before=docker-project

# Lists images created more recently than the "python" image.
docker image ls --filter since=python

# Displays "untagged" images that are no longer associated with a 
# repository name and are typically safe to prune.
docker image ls --filter dangling=true

# Filters images based on custom metadata labels that match
# the "python*" pattern.
docker image ls --filter label=python*

# Outputs a customized, tab-separated table containing specific
# image metadata fields for better readability.
docker image ls --format \
"table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}\t\
{{.CreatedAt}}\t{{.Digest}}"
```

### Tags and Labels (Branch 03_03)

#### Tags

- used to identify distinct versions of an image.
- It is common practice to use tags to mark each release **so users can select between different versions.**
- In `python:3.12-rc-bookworm` , everything following `:` is tag
- Industry standard - version followed by operating system or other key dependency

```bash
docker build -t SOURCE_IMAGE[:TAG] .

docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

- When no tag is defined, docker assumes that the image created is the latest version of the images in the repo.

### Running a container (Branch 04_01)

```bash
# Build image
docker build -t big-star-collectible:v3 .

# Run container
docker run -it -d -p 5001:5000 -v ${PWD}:/app/code big-star-collectibles:v3
```

### Working with volumes and mounts (Branch 04_05)

- On using docker volume, data inside is not stored in container’s file system, but in the host machine’s file system. Meaning data in volume persists even if container is deleted or recreated

```bash
docker volume create big-star-collectibles-vol

# List all volumes
docker volume ls

# Inspect
docker volume inspect <volume-name>

# To attach a volume to container, use the -v option for volume,
# and then specify the host path followed by container path
docker run -it -d -p 5000:5000 -v <host-path>:<container-path>

docker exec -it <container-id> sh
```

- Use volumes to persist data across containers
- When a bind mount is used, a specific file or directory on the host machine is directly mounted **into a directory inside the container.**
    - This means that any data written to that directory within the container is actually written to the corresponding location on the host machine's file system, and once again, remove the running container.
- There are two options for specifying mount using the `-v` or `--mount` flags.
    - using the -v flag at all times, because if you specify a directory that does not exist on the host, using the -v flag will create it, **but the --mount flag will return an error.**

### Reviewing daily workflow

```bash

# -a to remove all images not used by existing container
# -f to bypass prompt
docker image prune -a -f

docker image prune -a -f --filter label="label-key"="label-value"

docker system prune

# Volumes are not included by default in prune command, so include 
# --volumes flag
docker system prune --volumes

```

