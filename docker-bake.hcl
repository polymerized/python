variable "DOCKER"  { default = "polymerized" }
variable "PROJECT" { default = "python" }

target "default" {
    dockerfile = "dockerfile"
    tags = [ "${DOCKER}/${PROJECT}:latest" ]
    platforms = [ "linux/amd64" ]
    args = {
        IMAGE       = "ubuntu"
        TAG         = "22.04"
        USER        = "user"
        USERCOLOR   = "30m"
        HOST        = "workspace"
        HOSTCOLOR   = "37m"
    }
}