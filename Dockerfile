FROM golang:1.26-alpine

# Set the working directory
WORKDIR /app

# Copies the go.mod file from the host machi to the /app container directory
COPY go.mod ./

# Downloads all dependencies specified in go.mod
RUN go mod download

# Same copie all the .go file to the host machine to /app container directory
COPY *.go ./

# Build the Go application creating an executable named pdm-golang which install in the root directory of the container image
RUN  go build -o /pdm-golang

# Say to podman that the container listens on port 8080
EXPOSE 8080

# Specify the command to run when the container starts
CMD ["/pdm-golang"]
