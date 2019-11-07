

### Notes

- it is highly recommended that you don't push an image based on this Dockerfile to a registry - since the root password is passed as a build argument, it means the password will be stored in the layers of the resulting image.
