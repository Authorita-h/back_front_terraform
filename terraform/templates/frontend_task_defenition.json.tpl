[
    {
        "name": "${workspace}-frontend-service",
        "image": "${image_repository_path}:frontend",
        "memory": 256,
        "essentials": true,
        "portMappings": [
            {
            "containerPort": 8080,
            "hostPort": 80
            }
        ]
    }
]