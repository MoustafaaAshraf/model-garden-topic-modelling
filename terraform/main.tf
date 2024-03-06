resource "google_cloud_scheduler_job" "function_scheduler" {
    name        = "function-scheduler"
    description = "Scheduler for triggering cloud function"

    schedule = "*/5 * * * *"
    time_zone = "UTC"

    http_target {
        uri = "https://your-cloud-function-url"
        http_method = "POST"
        headers = {
            "Content-Type" = "application/json"
        }
        body = <<EOF
        {
            "key": "value"
        }
        EOF
    }
}
resource "google_cloudfunctions_function" "my_function" {
    name        = "my-function"
    description = "Cloud Function triggered by scheduler"
    runtime     = "nodejs14"

    source_archive_bucket = google_storage_bucket.my_bucket.name
    source_archive_object = google_storage_bucket_object.my_function_zip.name

    entry_point = "myFunction"

    event_trigger {
        event_type = "google.pubsub.topic.publish"
        resource   = google_pubsub_topic.my_topic.name
    }

    timeout = "60s"
    available_memory_mb = 256

    environment_variables = {
        KEY = "VALUE"
    }
}

resource "google_storage_bucket" "my_bucket" {
    name     = "my-bucket"
    location = "US"
}

resource "google_storage_bucket_object" "my_function_zip" {
    name   = "my-function.zip"
    bucket = google_storage_bucket.my_bucket.name

    source = "/path/to/my-function.zip"
}

resource "google_pubsub_topic" "my_topic" {
    name = "my-topic"
}
