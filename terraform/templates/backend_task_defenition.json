[
    {
        "name": "${workspace}-backend-service",
        "image": "${image_repository_path}:latest",
        "memory": 256,
        "essentials": true,
        "portMappings": [
            {
            "containerPort": 3000,
            "hostPort": 3000
            }
        ],
        "environment": [
            {
            "name": "DB_HOST",
            "value": "${database_host}"
            },
            {
            "name": "DB_NAME",
            "value": "${database_name}"
            },
            {
            "name": "DB_PASSWORD",
            "value": "${database_password}"
            },
            {
            "name": "DB_USER",
            "value": "${database_user}"
            }
        ]
    }
]