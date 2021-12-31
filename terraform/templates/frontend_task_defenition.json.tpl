[
    {
        "name": "${workspace}-frontend-service",
        "image": "${image_repository_path}",
        "memory": 256,
        "essentials": true,
        "portMappings": [
            {
            "containerPort": ${frontend_port},
            "hostPort": ${frontend_port}
            }
        ],
        "environment": [
            {
            "name": "REACT_APP_BACKEND_HOSTNAME",
            "value": "https://${env}${backend_hostname}/"
            }
        ]
    }
]