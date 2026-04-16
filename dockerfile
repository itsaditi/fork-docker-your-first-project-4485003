# Use offical Python runtime as base image
FROM python:3.12-rc-bookworm

# Set working directory in the container to /app
WORKDIR /app

# Copy current directory contentsinto the container at /app
# COPY <current-dir> <dest-dir-within-container>
COPY . /app

# Install required packages
# --no-cache-dir - This tells pip not to use a cache when 
# installing packages, which ensures that the latest version 
# of the package is always used.
RUN pip install --no-cache-dir -r requirements.txt

# Set env variable for flask
ENV FLASK_APP=app.py

# Run command to start the Flask application
# Note - Docker file will only use the final command defined, so
#        you have to be careful while building docker files so that
#        you dont overwrite your default command
CMD [ "flask", "run", "--host=0.0.0.0" ]