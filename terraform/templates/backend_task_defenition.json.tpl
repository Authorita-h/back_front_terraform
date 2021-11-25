[
    {
        "name": "${workspace}-backend-service",
        "image": "${image_repository_path}:backend",
        "memory": 256,
        "essentials": true,
        "portMappings": [
            {
            "containerPort": 3000,
            "hostPort": 3000
            }
        ]
        "environment": [
        {
        "name": "DB_HOST",
        "value": "${database_host}"
        }
        ]
    }
]