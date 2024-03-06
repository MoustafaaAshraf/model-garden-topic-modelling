from google.cloud import bigquery
from vertexai.preview.language_models import TextGenerationModel


def find_topic(temperature: float = 0.2):
    """Find the topic of a text using a Large Language Model"""

    parameters = {
        "temperature": temperature,
        "max_output_tokens": 256,
        "top_p": 0.8,
        "top_k": 40,
    }

    model = TextGenerationModel.from_pretrained("text-bison@001")
    response = model.predict(
        "What is the topic of this text?",
        **parameters,
    )
    print(f"Topic predicted by the model: {response.text}")

    # Save the input and response to BigQuery
    client = bigquery.Client()
    table_id = "your-project.your-dataset.your-table"
    # Replace with your project, dataset, and table name

    row = {
        "input_text": "What is the topic of this text?",
        "predicted_topic": response.text,
    }

    table = client.get_table(table_id)
    errors = client.insert_rows(table, [row])

    if errors == []:
        print("Data inserted successfully.")
    else:
        print(f"Errors encountered while inserting data: {errors}")
